set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake-3.24.2-patch/Modules") # For patches.

set(CMAKE_SYSTEM_NAME Generic)

# You can set the tool paths here in stead of setting the environment variable `Path` on Windows.
set(TOOLCHAIN_PATH C:/Renesas/CS+/CC/CC-RL/V1.11.00/bin) # Quote the path with "..." if it includes space.
set(EXTERNAL_TOOLCHAIN_PATH C:/Renesas/e2studio64/SupportFiles/.eclipse/com.renesas.platform_275843822/Utilities/ccrl) # Quote the path with "..." if it includes space.  # For e2 studio.

set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/ccrl.exe)
set(CMAKE_RENESAS_XCONVERTER ${EXTERNAL_TOOLCHAIN_PATH}/renesas_cc_converter.exe) # In case of CS+, define the tool as "" or exclude the tool from `Path`.

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

# In case of other than Ninja, `-P` and `-S` cannot be used. Please quote the option
# with single quotation character as follow:
# '-S'
# '-P'

#---------------------------------------------------------------------
# Note: DebugComp, Internal and Utilities folder location of e² studio
#---------------------------------------------------------------------

# Renesas' FAQ
#
# https://en-support.renesas.com/knowledgeBase/19891761
# https://ja-support.renesas.com/knowledgeBase/19851044
