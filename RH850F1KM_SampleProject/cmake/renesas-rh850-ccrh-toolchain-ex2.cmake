#set(RENESAS_COMPILER_AUTO_DETECT ON) # ON: Do the compiler detection process with patches, Undefined or OFF: Eliminate the process.
if(NOT CMAKE_MODULE_PATH) # Somehow checking RENESAS_COMPILER_AUTO_DETECT needs this guard. I can't guess the root cause.
if(NOT RENESAS_COMPILER_AUTO_DETECT)
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is OFF")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../CMake-Compiler-RENESAS/Modules") # Tell CMake the path of support module for Renesas CC compilers.
set(CMAKE_C_COMPILER_ID RENESAS) # Tell CMake that the target compiler is one of Renesas CC compilers.
set(CMAKE_C_COMPILER_ID_RUN TRUE) # Tell CMake that the compiler detection process must be eliminated.

else()
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is ON")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake-3.26.0-patch/Modules") # For patches and support module for Renesas CC compilers.
#set(CMAKE_SYSTEM_NAME Generic) # The `Generic` can be specified. (Also in the above NOT RENESAS_COMPILER_AUTO_DETECT case.)

endif()
endif()

# You can set the tool paths here in stead of setting the environment variable `Path` on Windows.
set(TOOLCHAIN_PATH C:/Renesas/CS+/CC/CC-RH/V2.05.00/bin) # Quote the path with "..." if it includes space.
set(EXTERNAL_TOOLCHAIN_PATH C:/Renesas/e2studio64_v202301/eclipse/plugins/com.renesas.ide.supportfiles.rh850.ccrh.build.win32.x86_64_1.0.0.v20220616-0824/ccrh) # Quote the path with "..." if it includes space.  # For e2 studio.

set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/ccrh.exe)
set(CMAKE_RENESAS_XCONVERTER ${EXTERNAL_TOOLCHAIN_PATH}/renesas_cc_converter.exe) # In case of CS+, define the tool as "" or exclude the tool from `Path`.

#########
# FLAGS #
#########

set(CMAKE_C_STANDARD 99)
#set(CMAKE_C_STANDARD_REQUIRED ON) # CMake's default is OFF
#set(CMAKE_C_EXTENSIONS OFF) # CC-RX/RL/RH's default is ON

set(CMAKE_C_FLAGS   "-Xcpu=g3kh -goptimize -Xcharacter_set=utf8 -Xpass_source")
set(CMAKE_ASM_FLAGS "-Xcpu=g3kh -goptimize -Xcharacter_set=utf8")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Xasm_option=-Xprn_path=. -Xcref=.")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -Xprn_path=.")

set(CMAKE_EXE_LINKER_FLAGS "-optimize=symbol_delete -entry=__cstart -stack \
-library=v850e3v5/rhf8n.lib,v850e3v5/libmalloc.lib \
-start=RESET/0,EIINTTBL.const/00000200,.const,.INIT_DSEC.const,.INIT_BSEC.const,.text,.data/00008000,.data.R,.bss,.stack.bss/FEDE8000 \
-rom=.data=.data.R \
-change_message=warning=2300,2142 -change_message=information=1321,1110 -total_size -list -show=all \
")

#######
# END #
#######

#------------------------------------------------------
# Note: Renesas exe linker options' additional behavior
#------------------------------------------------------

# If `-form=` is not specified, both -form=abs and -form=s are regarded as being specified.
#
# If only -form=s is specified, -form=abs is regarded as being specified. On the other hand,
# if only -form=abs is specified, -form=s is not regarded as being specified.
#
# If only either of -form=<hex|bin> is specified, -form=abs is regarded as being specified
# but -form=s is not regarded as being specified in addition to the -form=<hex|bin>.
#
# If -form=abs and one of -form=<s|hex|bin> are specified simultaneously, Renesas linker is
# executed twice. The first execution is performed with -form=abs, the second execution is
# performed with the specified one of -form=<s|hex|bin>. In the case, the following options
# are regarded as being specified for the second execution if these options are specified.
# -byte_count=<num>
# -fix_record_length_and_align=<num>
# -record=<item>
# -end_record=<item>
# -s9
# -space[=<num|item>]
# -crc=<sub_option>
# -output=<sub_option>

# If `-library=` is specified with relative paths, both of the following folders are also searched.
# <compiler path>/lib
# <compiler path>

#----------------------------------------------------
# Note: Renesas compiler options' additional behavior
#----------------------------------------------------

# The following usage is deprecated because CMake 3.26.0-rc2 no longer causes any problem.
## In case of other than Ninja, `-P` and `-S` cannot be used. Please quote the option
## with single quotation character as follow:
## '-S'
## '-P'

#---------------------------------------------------------------------
# Note: DebugComp, Internal and Utilities folder location of e2 studio
#---------------------------------------------------------------------

# Renesas' FAQ
#
# https://en-support.renesas.com/knowledgeBase/19891761
# https://ja-support.renesas.com/knowledgeBase/19851044
