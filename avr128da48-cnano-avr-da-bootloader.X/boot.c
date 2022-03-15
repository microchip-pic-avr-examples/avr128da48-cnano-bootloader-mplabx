/**
 * \file boot.c
 *
 * \brief Main boot function.
 *
 (c) 2019 Microchip Technology Inc. and its subsidiaries.
    Subject to your compliance with these terms, you may use this software and
    any derivatives exclusively with Microchip products. It is your responsibility
    to comply with third party license terms applicable to your use of third party
    software (including open source software) that may accompany Microchip software.
    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE.
    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
    BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
    FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
    ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
    THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
 *
 */

#define F_CPU                           (4000000UL)         /* using clock 4MHz*/
#define UART_BAUD_RATE					(115200UL)
#define USART0_BAUD_RATE(BAUD_RATE)     ((float)(64 * F_CPU / (16 * (float)BAUD_RATE)) + 0.5)

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <string.h>
#include <stdbool.h>
#include "conf_bootloader.h"
#include "flash_access.h"

/* Interface function prototypes */
#define BOOTLOADER_isRequested()    BUTTON_read()
#define INTERFACE_init()            USART_init()
#define INTERFACE_readByte()        USART_read()
#define INTERFACE_writeByte(a)      USART_write(a)

/* Fuse configuration
 * BOOTSIZE sets the size (end) of the boot section in blocks of 512 bytes.
 * CODESIZE = 0x00 defines the section from BOOTSIZE*512 to end of Flash as application code.
 * Remaining fuses have configuration that the app depends on.
 */
FUSES = {
	.BODCFG = ACTIVE_DISABLE_gc | LVL_BODLEVEL0_gc | SAMPFREQ_128Hz_gc | SLEEP_DISABLE_gc,
	.BOOTSIZE = BOOTSIZE_FUSE,
	.CODESIZE = 0,
	.OSCCFG = CLKSEL_OSCHF_gc,
	.SYSCFG0 = CRCSEL_CRC16_gc | CRCSRC_NOCRC_gc | RSTPINCFG_GPIO_gc,
	.SYSCFG1 = SUT_0MS_gc,
	.WDTCFG = PERIOD_OFF_gc | WINDOW_OFF_gc,
};

typedef enum
{
    READ_START_MARK = 0,
    READ_APP_INFO,
    READ_IMG_START_MARK,
    WRITE_FLASH,
    SOFTWARE_RESET,
}boot_state_t;

boot_state_t boot_state;

uint8_t rx_data;
uint32_t cnt;
uint32_t current_mark;
volatile uint8_t* app_ptr;
volatile uint32_t flash_addr;
application_code_info image_info;

/* Communication interface */
static void USART_init(void);
static uint8_t USART_read(void);
static void USART_write(uint8_t byte);

/* User interface functions */
static inline void STATUS_LED_init(void);
static inline void STATUS_LED_toggle(void);
static inline void STATUS_LED_set(void);
static inline void STATUS_LED_clear(void);
static uint8_t BUTTON_read(void);
static inline void RS485_TXEN_init(void);
static inline void RS485_TXEN_set(void);
static inline void RS485_TXEN_clear(void);

/* Bootloader function */
void bootloader(void);

/*
 * Main boot function
 * It represents the enter point for the device to start execution
 * It will be placed in the constructors section (.ctors) of the AVR GCC code project
 * Naked attribute instructs the compiler to omit the function prologue and epilogue
 */
__attribute__((naked)) __attribute__((section(".ctors"))) void boot(void)
{
    /* Initialize system for AVR GCC support, expects r1 = 0 */
    asm volatile("clr r1");
    
    STATUS_LED_init();
    STATUS_LED_set();
    /* Check if entering application or continuing to bootloader */
    if(!BOOTLOADER_isRequested()) 
    {
        STATUS_LED_clear();

        /* Enable Boot Section Lock */
        NVMCTRL.CTRLB = NVMCTRL_BOOTRP_bm;
 
        /* Jump to application, located immediately after boot section */
        pgm_jmp_far(APPCODE_START / sizeof(uint16_t));
    }
    
    /* Execute the bootloader code */ 
    bootloader();     
}

void bootloader(void)
{
    uint16_t data_word = 0;
    volatile uint16_t cksum = 0u;
    /* Initialize communication interface */
    INTERFACE_init();
    RS485_TXEN_init();
    boot_state = READ_START_MARK;
    
    while (1)
    {
        if (boot_state < SOFTWARE_RESET)
        {
            /* Receive byte from communication interface */
            rx_data = INTERFACE_readByte();
        }
            
        switch(boot_state)
        {
            case READ_START_MARK:
                current_mark <<= 8;
                current_mark &= 0xFFFFFF00;
                current_mark |= (rx_data & 0xFF);
                if (current_mark == BOOTLOADER_START_MARK)
                {
                    /* If "INFO" tag was received, continue with reading the app info */
                    boot_state = READ_APP_INFO;
                    image_info.start_mark = current_mark;
                    app_ptr = (uint8_t*)(&image_info);
                    app_ptr += MARK_SIZE;
                    cnt = MARK_SIZE;
                }
            break;
            
            case READ_APP_INFO:
                *app_ptr = rx_data;
                app_ptr++;
                cnt++;
                
                if (cnt == sizeof(application_code_info))
                {
                    /* If all the information section was received, continue with reading "STX0" tag */
                    boot_state = READ_IMG_START_MARK;
                    cnt = 0;
                    /* Update the start address for the application code */
                    flash_addr = image_info.start_address;
                }
            break;
            
            case READ_IMG_START_MARK:
                current_mark <<= 8;
                current_mark &= 0xFFFFFF00;
                current_mark |= (rx_data & 0xFF);
                cnt++;
                if (current_mark == BOOTLOADER_IMG_START_MARK)
                {
                    /* If "STX0" tag was received, continue with storing the application image in the Flash */
                    boot_state = WRITE_FLASH;
                    cnt = 0;
                }
                else 
                {
                    if (cnt > MARK_SIZE)
                    {   
                        /* Restart waiting for start mark */
                        boot_state = READ_START_MARK;
                    }                        
                }                    
            break;
            
            case WRITE_FLASH:
                /* Page boundary reached, first erase */
                if((cnt % MAPPED_PROGMEM_PAGE_SIZE) == 0x0000)
                {
                    /* Wait for completion of previous write */
                    while (NVMCTRL.STATUS & (NVMCTRL_EEBUSY_bm | NVMCTRL_FBUSY_bm))
                    {
                        ;
                    }                        
                    /* Clear the current command */
                    _PROTECTED_WRITE_SPM(NVMCTRL.CTRLA, NVMCTRL_CMD_NONE_gc);
        
                    /* Erase the flash page */
                    /* Send erase command */
                    _PROTECTED_WRITE_SPM(NVMCTRL.CTRLA, NVMCTRL_CMD_FLPER_gc);
                    
                    /* Dummy write to start erase operation */
                    pgm_word_write(flash_addr, 0x00);
                    
                    /* Wait for completion of previous write */
                    while (NVMCTRL.STATUS & (NVMCTRL_EEBUSY_bm | NVMCTRL_FBUSY_bm))
                    {
                        ;
                    }                        
                    /* Clear the current command */
                    _PROTECTED_WRITE_SPM(NVMCTRL.CTRLA, NVMCTRL_CMD_NONE_gc);
                    
                    STATUS_LED_toggle();

                    /* Enable flash Write Mode */
                    _PROTECTED_WRITE_SPM(NVMCTRL.CTRLA, NVMCTRL_CMD_FLWR_gc);
                }
        
                if ((flash_addr & 0x01) == 0)
                {
                    data_word = rx_data;
                }
                else
                {    
                    data_word |= (rx_data << 8);
                    
                    /* Program flash word with desired value */
                    pgm_word_write((flash_addr & 0xFFFFFE), data_word);
                }

                /* Increment address before writing to Flash */
                flash_addr++;
                
                cnt++;
                if (cnt == image_info.memory_size)
                {
                    /* If all the image was stored, continue with Software reset */
                    boot_state = SOFTWARE_RESET;
                }            
            break;
            
            case SOFTWARE_RESET:
                /*Read back the image and add the bytes for a 16 bit checksum*/
                for(uint32_t i = image_info.start_address; i < (image_info.start_address + image_info.memory_size); i++)
                {
                    cksum += pgm_read_byte_far(i);
                }
                INTERFACE_writeByte((cksum >> 8u) & 0xFF);
                INTERFACE_writeByte(cksum & 0xFF);
                _delay_ms(50);
                /* Software reset after download */
                _PROTECTED_WRITE(RSTCTRL.SWRR, RSTCTRL_SWRST_bm);

            break;
            
            default:
            break;
        }
            
        /* Echo the received byte on the communication interface */
        INTERFACE_writeByte(rx_data);
    }
}

/*
 * Communication interface functions
 */
static void USART_init(void)
{
    VPORTA.DIR &= ~PIN1_bm;                                 /* set pin 1 of PORT A (RXd) as input*/
    VPORTA.DIR |= PIN0_bm;                                  /* set pin 0 of PORT C (TXd) as output*/

    //set baud rate register
    USART0.BAUD = (uint16_t)USART0_BAUD_RATE(UART_BAUD_RATE);
	
    //RXCIE enabled; TXCIE enabled; DREIE disabled; RXSIE enabled; LBME disabled; ABEIE disabled; RS485 DISABLE; 
    USART0.CTRLA = 0xD0;
	
    //RXEN enabled; TXEN enabled; SFDEN disabled; ODME disabled; RXMODE NORMAL; MPCM disabled; 
    USART0.CTRLB = 0xC0;
	
    //CMODE ASYNCHRONOUS; PMODE Disabled; SBMODE 1BIT; CHSIZE 8BIT; UDORD disabled; UCPHA disabled; 
    USART0.CTRLC = 0x03;
	
    //DBGCTRL_DBGRUN
    USART0.DBGCTRL = 0x00;
	
    //EVCTRL_IREI
    USART0.EVCTRL = 0x00;
	
    //RXPLCTRL_RXPL
    USART0.RXPLCTRL = 0x00;
	
    //TXPLCTRL_TXPL
    USART0.TXPLCTRL = 0x00;
 
 }

static uint8_t USART_read(void)
{
    /* Poll for data received */
    while (!(USART0.STATUS & USART_RXCIF_bm))
    {
        ;
    }  
      
    return USART0.RXDATAL;
}

static void USART_write(uint8_t byte)
{
    while (!(USART0.STATUS & USART_DREIF_bm))
    {
        ;
    } 
    RS485_TXEN_set();       
    /* Data will be sent when TXDATA is written */
    USART0.TXDATAL = byte;
    while (!(USART0.STATUS & USART_TXCIF_bm))
    {
        ;
    }
    RS485_TXEN_clear();
    USART0.STATUS |= (USART_TXCIF_bm);
}

/*
 * User interface functions
 */
static inline void STATUS_LED_init(void)
{
    /* Set LED0 (PF2) as output */
    VPORTF.DIR |= PIN2_bm;
}

static inline void STATUS_LED_toggle(void)
{
    /* Toggle LED0 (PF2) */
    VPORTF.OUT ^= PIN2_bm;
}

static inline void STATUS_LED_set(void)
{
    /* Toggle LED0 (PF2) */
    VPORTF.OUT |=  PIN2_bm;
}

static inline void STATUS_LED_clear(void)
{
    /* Toggle LED0 (PF2) */
    VPORTF.OUT &=  ~PIN2_bm;
}

static uint8_t BUTTON_read(void)
{
    /* Read value on BLEN (PF4) */
    return (!(VPORTF.IN & PIN4_bm));
}

static inline void RS485_TXEN_init(void)
{
    /* Set TXEN (PA3) as output */
    VPORTA.DIR |= PIN3_bm;
}

static inline void RS485_TXEN_set(void)
{
    /* Set TXEN (PA3) */
    VPORTA.OUT |=  PIN3_bm;
}

static inline void RS485_TXEN_clear(void)
{
    /* Clear TXEN (PA3) */
    VPORTA.OUT &=  ~PIN3_bm;
}
