#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-Release.mk)" "nbproject/Makefile-local-Release.mk"
include nbproject/Makefile-local-Release.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=Release
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=boot.c flash_access.S

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/boot.o ${OBJECTDIR}/flash_access.o
POSSIBLE_DEPFILES=${OBJECTDIR}/boot.o.d ${OBJECTDIR}/flash_access.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/boot.o ${OBJECTDIR}/flash_access.o

# Source Files
SOURCEFILES=boot.c flash_access.S

# Pack Options 
PACK_COMPILER_OPTIONS=-I "${DFP_DIR}/include"
PACK_COMMON_OPTIONS=-B "${DFP_DIR}/gcc/dev/avr128da32"



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-Release.mk dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA32
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/flash_access.o: flash_access.S  .generated_files/40d77cc880bc79b2fe657596100d8b1f6596a261.flag .generated_files/499d67f7b5acbe8a8ce3e6f0b0d91dfb6ecc2c12.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/flash_access.o.d 
	@${RM} ${OBJECTDIR}/flash_access.o 
	@${RM} ${OBJECTDIR}/flash_access.o.ok ${OBJECTDIR}/flash_access.o.err 
	 ${MP_CC} $(MP_EXTRA_AS_PRE) -mmcu=avr128da32 ${PACK_COMPILER_OPTIONS} ${PACK_COMMON_OPTIONS}  -DDEBUG  -x assembler-with-cpp -c -D__$(MP_PROCESSOR_OPTION)__  -MD -MP -MF "${OBJECTDIR}/flash_access.o.d" -MT "${OBJECTDIR}/flash_access.o.d" -MT ${OBJECTDIR}/flash_access.o -o ${OBJECTDIR}/flash_access.o flash_access.S  -DXPRJ_Release=$(CND_CONF)  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/flash_access.o.asm.d",--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--gdwarf-2,--defsym=__DEBUG=1
	
else
${OBJECTDIR}/flash_access.o: flash_access.S  .generated_files/d41d6008076619c457b3ce2ebdc207bd7a94e515.flag .generated_files/499d67f7b5acbe8a8ce3e6f0b0d91dfb6ecc2c12.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/flash_access.o.d 
	@${RM} ${OBJECTDIR}/flash_access.o 
	@${RM} ${OBJECTDIR}/flash_access.o.ok ${OBJECTDIR}/flash_access.o.err 
	 ${MP_CC} $(MP_EXTRA_AS_PRE) -mmcu=avr128da32 ${PACK_COMPILER_OPTIONS} ${PACK_COMMON_OPTIONS}  -x assembler-with-cpp -c -D__$(MP_PROCESSOR_OPTION)__  -MD -MP -MF "${OBJECTDIR}/flash_access.o.d" -MT "${OBJECTDIR}/flash_access.o.d" -MT ${OBJECTDIR}/flash_access.o -o ${OBJECTDIR}/flash_access.o flash_access.S  -DXPRJ_Release=$(CND_CONF)  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),-MD="${OBJECTDIR}/flash_access.o.asm.d"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/boot.o: boot.c  .generated_files/3457c071414ce6dfbd098595533198113c87b464.flag .generated_files/499d67f7b5acbe8a8ce3e6f0b0d91dfb6ecc2c12.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/boot.o.d 
	@${RM} ${OBJECTDIR}/boot.o 
	 ${MP_CC}  $(MP_EXTRA_CC_PRE) -mmcu=avr128da32 ${PACK_COMPILER_OPTIONS} ${PACK_COMMON_OPTIONS} -g -DDEBUG  -gdwarf-2  -x c -c -D__$(MP_PROCESSOR_OPTION)__  -funsigned-char -funsigned-bitfields -O3 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -DNDEBUG -Wall -MD -MP -MF "${OBJECTDIR}/boot.o.d" -MT "${OBJECTDIR}/boot.o.d" -MT ${OBJECTDIR}/boot.o  -o ${OBJECTDIR}/boot.o boot.c  -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD) 
	
else
${OBJECTDIR}/boot.o: boot.c  .generated_files/d285991d1631e5be4e0cce71a38faa25e34f2b79.flag .generated_files/499d67f7b5acbe8a8ce3e6f0b0d91dfb6ecc2c12.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/boot.o.d 
	@${RM} ${OBJECTDIR}/boot.o 
	 ${MP_CC}  $(MP_EXTRA_CC_PRE) -mmcu=avr128da32 ${PACK_COMPILER_OPTIONS} ${PACK_COMMON_OPTIONS}  -x c -c -D__$(MP_PROCESSOR_OPTION)__  -funsigned-char -funsigned-bitfields -O3 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -DNDEBUG -Wall -MD -MP -MF "${OBJECTDIR}/boot.o.d" -MT "${OBJECTDIR}/boot.o.d" -MT ${OBJECTDIR}/boot.o  -o ${OBJECTDIR}/boot.o boot.c  -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD) 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compileCPP
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mmcu=avr128da32 ${PACK_COMMON_OPTIONS}   -gdwarf-2 -D__$(MP_PROCESSOR_OPTION)__  -nostartfiles -Wl,-Map="dist\${CND_CONF}\${IMAGE_TYPE}\avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.map"    -o dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}      -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1 -Wl,--gc-sections -Wl,--start-group  -Wl,-lm -Wl,-lm -Wl,--end-group 
	
	${MP_CC_DIR}\\avr-objcopy -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.eep" || exit 0
	${MP_CC_DIR}\\avr-objdump -h -S "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" > "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.lss"
	${MP_CC_DIR}\\avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.srec"
	
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mmcu=avr128da32 ${PACK_COMMON_OPTIONS}  -D__$(MP_PROCESSOR_OPTION)__  -nostartfiles -Wl,-Map="dist\${CND_CONF}\${IMAGE_TYPE}\avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.map"    -o dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}      -DXPRJ_Release=$(CND_CONF)  $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION) -Wl,--gc-sections -Wl,--start-group  -Wl,-lm -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.hex"
	${MP_CC_DIR}\\avr-objcopy -j .eeprom --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0 --no-change-warnings -O ihex "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.eep" || exit 0
	${MP_CC_DIR}\\avr-objdump -h -S "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" > "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.lss"
	${MP_CC_DIR}\\avr-objcopy -O srec -R .eeprom -R .fuse -R .lock -R .signature "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "dist/${CND_CONF}/${IMAGE_TYPE}/avr128da48-cnano-avr-da-bootloader.X.${IMAGE_TYPE}.srec"
	
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/Release
	${RM} -r dist/Release

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
