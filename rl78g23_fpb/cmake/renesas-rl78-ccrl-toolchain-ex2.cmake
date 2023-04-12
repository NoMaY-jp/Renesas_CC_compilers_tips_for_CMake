#set(RENESAS_COMPILER_AUTO_DETECT ON) # ON: Do the compiler detection process with patches, Undefined or OFF: Eliminate the process.
if(NOT CMAKE_MODULE_PATH) # Somehow checking RENESAS_COMPILER_AUTO_DETECT needs this guard. I can't guess the root cause.
if(NOT RENESAS_COMPILER_AUTO_DETECT)
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is OFF")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../CMake-Compiler-RENESAS/Modules") # Tell CMake the path of support module for Renesas CC compilers.
set(CMAKE_C_COMPILER_ID RENESAS) # Tell CMake that the target compiler is one of Renesas CC compilers.
set(CMAKE_C_COMPILER_ID_RUN TRUE) # Tell CMake that the compiler detection process must be eliminated.

else()
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is ON")

include(${CMAKE_CURRENT_LIST_DIR}/set-cmake-module-path-for-patches-detecting-renesas-cc-compilers.cmake) # For patches and support module for Renesas CC compilers.
#set(CMAKE_SYSTEM_NAME Generic) # The `Generic` can be specified. (Also in the above NOT RENESAS_COMPILER_AUTO_DETECT case.)

endif()
endif()

# You can set the tool paths here in stead of setting the environment variable `Path` on Windows.
set(TOOLCHAIN_PATH C:/Renesas/CS+/CC/CC-RL/V1.12.00/bin) # Quote the path with "..." if it includes space.
set(EXTERNAL_TOOLCHAIN_PATH C:/Renesas/e2studio64/SupportFolders/.eclipse/com.renesas.platform_733684649/Utilities/ccrl) # Quote the path with "..." if it includes space.  # For e2 studio.

set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/ccrl.exe)
set(CMAKE_RENESAS_XCONVERTER ${EXTERNAL_TOOLCHAIN_PATH}/renesas_cc_converter.exe) # In the case of CS+, define the tool as "" or exclude the tool from `Path`.

#########
# FLAGS #
#########

set(CMAKE_C_STANDARD 99)
#set(CMAKE_C_STANDARD_REQUIRED ON) # CMake's default is OFF
#set(CMAKE_C_EXTENSIONS OFF) # CC-RX/RL/RH's default is ON

set(CMAKE_C_FLAGS   "-cpu=S3 -goptimize -character_set=utf8 -refs_without_declaration -pass_source")
set(CMAKE_ASM_FLAGS "-cpu=S3 -goptimize -character_set=utf8")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -asmopt=-prn_path=. -cref=.")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -prn_path=.")

string(JOIN " " CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${INTELLISENSE_HELPER_C_FLAGS}) # Tell IntelliSence engine about workaround flags.

set(CMAKE_EXE_LINKER_FLAGS "-optimize=branch,symbol_delete -entry=_start -stack \
-library=rl78em4r.lib,rl78em4s99.lib,malloc_n.lib \
-device=DR7F100GLG.DVF \
-auto_section_layout \
-rom=.data=.dataR,.sdata=.sdataR \
-user_opt_byte=EFFFE8 \
-ocdbg=85 \
-security_id=00000000000000000000 \
-debug_monitor=1FF00-1FFFF \
-change_message=warning=2300,2142 -change_message=information=1321,1110 -total_size -list -show=all \
")

#######
# END #
#######

#----------------------------------------
# Note: Renesas pseudo exe linker options
#----------------------------------------

# -xcopt=<XConverter options>
# The `-xcopt=` is not a native option of either Renesas Linker or Renesas XConverter.
# It is intended to be used for CMake's wrapper scripts for Renesas build tools.
# The <XConvert options> are passed not to rlink.exe but to renesas_cc_converter.exe.

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

# If `-device=` is specified with relative path, either of the following folders is also searched.
# <install path of CS+ for CC>/Device/RL78/Devicefile
# <support area path of e2 studio>/DebugComp/RL78/RL78/Common
#
# Please be aware that actual implementation is as follow.
# <folder path containing rlink.exe>/../../../Device/RL78/Devicefile
# <folder path containing renesas_cc_converter.exe>/../../DebugComp/RL78/RL78/Common

#----------------------------------------------------
# Note: Renesas compiler options' additional behavior
#----------------------------------------------------

# The following usage is deprecated because CMake 3.26.0-rc2 no longer causes any problem.
## In the case of other than Ninja, `-P` and `-S` cannot be used. Please quote the option
## with single quotation character as follow:
## '-S'
## '-P'

# When the language standard such as C90 or C99 is specified by CMake's language standard variables
# and/or commands, the following definitions may be passed to not only LLVM clangd language server
# but also CC-RL by `-D` option as follows.
# -DINTELISENSE_HELPER_C_STANDARD=<value>
# -DINTELISENSE_HELPER_C_EXTENSIONS=<value>

#---------------------------------------------------------------------
# Note: DebugComp, Internal and Utilities folder location of e2 studio
#---------------------------------------------------------------------

# Renesas' FAQ
#
# https://en-support.renesas.com/knowledgeBase/19891761
# https://ja-support.renesas.com/knowledgeBase/19851044
