set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake-3.26.0-patch/Modules") # For patches.

set(CMAKE_SYSTEM_NAME Generic)

# You can set the tool paths here in stead of setting the environment variable `Path` on Windows.
set(TOOLCHAIN_PATH C:/Renesas/CS+/CC/CC-RH/V2.05.00/bin) # Quote the path with "..." if it includes space.
set(EXTERNAL_TOOLCHAIN_PATH C:/Renesas/e2studio64_v202301/eclipse/plugins/com.renesas.ide.supportfiles.rh850.ccrh.build.win32.x86_64_1.0.0.v20220616-0824/ccrh) # Quote the path with "..." if it includes space.  # For e2 studio.

set(CMAKE_PROGRAM_PATH ${TOOLCHAIN_PATH} ${EXTERNAL_TOOLCHAIN_PATH})

set(CMAKE_C_COMPILER ccrh -Xcpu=g3kh)
#set(CMAKE_RENESAS_XCONVERTER "") # In case of CS+, define the tool as "" like this or exclude the tool from `Path`.

############################
macro(SET_DIRECTORY_OPTIONS)
############################

set(CMAKE_C_STANDARD 99)

add_link_options(
-library=v850e3v5/rhf8n.lib,v850e3v5/libmalloc.lib
-start=RESET/0,EIINTTBL.const/00000200,.const,.INIT_DSEC.const,.INIT_BSEC.const,.text,.data/00008000,.data.R,.bss,.stack.bss/FEDE8000
-rom=.data=.data.R
)

##########
endmacro()
##########

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
