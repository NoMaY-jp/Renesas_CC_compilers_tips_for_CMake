#set(RENESAS_COMPILER_AUTO_DETECT ON) # ON: Do the compiler detection process with patches, Undefined or OFF: Eliminate the process.
if(NOT CMAKE_MODULE_PATH) # Somehow checking RENESAS_COMPILER_AUTO_DETECT needs this guard. I can't guess the root cause.
if(NOT RENESAS_COMPILER_AUTO_DETECT)
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is OFF")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../CMake-Compiler-RENESAS/Modules") # Tell CMake the path of support module for Renesas CC compilers.
if(EXAMPLE_CXX_PROJ_TYPE EQUAL 1)
  set(CMAKE_CXX_COMPILER_ID RENESAS) # Tell CMake that the target compiler is one of Renesas CC compilers.
  set(CMAKE_CXX_COMPILER_ID_RUN TRUE) # Tell CMake that the compiler detection process must be eliminated.
  #set(CMAKE_C_COMPILER_ID RENESAS) # This can be set simultaneously.
  #set(CMAKE_C_COMPILER_ID_RUN TRUE) # This can be set simultaneously.
elseif(EXAMPLE_CXX_PROJ_TYPE EQUAL 2)
  set(CMAKE_C_COMPILER_ID RENESAS) # Tell CMake that the target compiler is one of Renesas CC compilers.
  set(CMAKE_C_COMPILER_ID_RUN TRUE) # Tell CMake that the compiler detection process must be eliminated.
  #set(CMAKE_CXX_COMPILER_ID RENESAS) # This can be set simultaneously.
  #set(CMAKE_CXX_COMPILER_ID_RUN TRUE) # This can be set simultaneously.
endif()

else()
message("DEBUG: RENESAS_COMPILER_AUTO_DETECT is ON")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake-3.26.0-patch/Modules") # For patches and support module for Renesas CC compilers.
#set(CMAKE_SYSTEM_NAME Generic) # The `Generic` can be specified. (Also in the above NOT RENESAS_COMPILER_AUTO_DETECT case.)

endif()
endif()

# You can set the tool paths here in stead of setting the environment variable `Path` on Windows.
set(TOOLCHAIN_PATH C:/Renesas/CS+/CC/CC-RX/V3.05.00/bin) # Quote the path with "..." if it includes space.
set(EXTERNAL_TOOLCHAIN_PATH C:/Renesas/e2studio64/SupportFolders/.eclipse/com.renesas.platform_733684649/Utilities/ccrx) # Quote the path with "..." if it includes space.  # For e2 studio.

if(RENESAS_COMPILER_AUTO_DETECT)
# The following setting improves the detection process of CC-RX a little bit faster.
set(ENV{BIN_RX} ${TOOLCHAIN_PATH})
endif()

if(EXAMPLE_CXX_PROJ_TYPE EQUAL 1)
  set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PATH}/ccrx.exe)
  #set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/ccrx.exe) # This can be set simultaneously.
elseif(EXAMPLE_CXX_PROJ_TYPE EQUAL 2)
  set(CMAKE_C_COMPILER ${TOOLCHAIN_PATH}/ccrx.exe)
  #set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PATH}/ccrx.exe) # This can be set simultaneously.
endif()
set(CMAKE_RENESAS_XCONVERTER ${EXTERNAL_TOOLCHAIN_PATH}/renesas_cc_converter.exe) # In case of CS+, define the tool as "" or exclude the tool from `Path`.

#########################
macro(SET_TARGET_OPTIONS)
#########################

set_property(TARGET tb_rx65n sample_lib1 sample_lib2 sample_lib3 PROPERTY C_STANDARD 99)
#set_property(TARGET tb_rx65n sample_lib1 sample_lib2 sample_lib3 PROPERTY C_STANDARD_REQUIRED ON) # CMake's default is OFF.
#set_property(TARGET tb_rx65n sample_lib1 sample_lib2 sample_lib3 PROPERTY C_EXTENSIONS OFF) # CC-RX/RL/RH's default is ON and CC-RX has no strict standard option.

set_target_properties(tb_rx65n PROPERTIES SUFFIX ".elf") # TODO: Not only using XConverter but also not using it.

target_compile_options(tb_rx65n PRIVATE
$<$<COMPILE_LANGUAGE:C,CXX>:-isa=rxv2 -goptimize -type_size_access_to_volatile -outcode=utf8 -utf8 -nomessage=21644,20010,23034,23035,20177,23033>
$<$<COMPILE_LANGUAGE:CXX>:-lang=ecpp> # -lang=cpp -exception -rtti=on
$<$<COMPILE_LANGUAGE:ASM>:-isa=rxv2 -goptimize -utf8>
$<$<COMPILE_LANGUAGE:C,CXX>:-listfile=.>
$<$<COMPILE_LANGUAGE:ASM>:-listfile=. -define=aaa,bbb=999,ccc,ddd="qqq",eee> # Somehow not `"qqq"` but `qqq` is passed to the assembler.
$<$<COMPILE_LANGUAGE:C,CXX>:-debug -g_line> # This line is intended for test purpose.
$<$<COMPILE_LANGUAGE:ASM>:-debug > # This line is intended for test purpose.
)
target_compile_options(sample_lib1 PRIVATE
$<$<COMPILE_LANGUAGE:C>:-isa=rxv2 -goptimize -type_size_access_to_volatile -outcode=utf8 -utf8 -nomessage=21644,20010,23034,23035,20177,23033>
$<$<COMPILE_LANGUAGE:C>:-listfile=.>
$<$<COMPILE_LANGUAGE:C,CXX>:-debug -g_line> # This line is intended for test purpose.
)
target_compile_options(sample_lib2 PRIVATE
$<$<COMPILE_LANGUAGE:C>:-isa=rxv2 -goptimize -type_size_access_to_volatile -outcode=utf8 -utf8 -nomessage=21644,20010,23034,23035,20177,23033>
$<$<COMPILE_LANGUAGE:C>:-listfile=.>
$<$<COMPILE_LANGUAGE:C,CXX>:-debug -g_line> # This line is intended for test purpose.
)
target_compile_options(sample_lib3 PRIVATE
$<$<COMPILE_LANGUAGE:C>:-isa=rxv2 -goptimize -type_size_access_to_volatile -outcode=utf8 -utf8 -nomessage=21644,20010,23034,23035,20177,23033>
$<$<COMPILE_LANGUAGE:C>:-listfile=.>
$<$<COMPILE_LANGUAGE:C,CXX>:-debug -g_line> # This line is intended for test purpose.
)

target_library_generate_options(tb_rx65n PRIVATE
-isa=rxv2 -goptimize -type_size_access_to_volatile -outcode=utf8 -utf8 -nomessage=21644,20010,23034,23035,20177,23033
-debug -g_line # This line is intended for test purpose.
-no_warning=20826 -preinclude=${CMAKE_CURRENT_LIST_DIR}/src/pre_include.h # This line is intended for test purpose.
)
target_library_generate_options(tb_rx65n PRIVATE # Dividing the command is intended for test purpos.
#-head=runtime,ctype,math,mathf,stdarg,stdio,stdlib,string,ios,new,complex,cppstring,c99_complex,fenv,inttypes,wchar,wctype
)
# Unfortunately, in case of Ninja, there are several minutes without any messages during execution
# of library generator actually generating or regenerating libraries. Please wait for a while.

target_link_options(tb_rx65n PRIVATE
-optimize=short_format,branch,symbol_delete -stack
-start=SU,SI,B_1,R_1,B_2,R_2,B,R/04,P,C_1,C_2,C,C$*,D*,W*,L/0FFE00000,EXCEPTVECT/0FFFFFF80,RESETVECT/0FFFFFFFC
-rom=D=R,D_1=R_1,D_2=R_2
-vect=_undefined_interrupt_source_isr
#-change_message=warning=2300,2142 -total_size -list -show=all # See next two lines.
LINKER:SHELL:-change_message=warning=2300,2142 # This style is intended for test purpos only.
LINKER:-total_size,-list,-show=all # This style is intended for test purpos only.
-form=s -byte_count=20 -xcopt=-dsp_section=DSP
-debug) # This line is intended for test purpose.

# The following setting selects the output type of compilation of the source.
if(NOT DEFINED EXAMPLE_ALT_OUTPUT_TYPE)
  set(EXAMPLE_ALT_OUTPUT_TYPE 0) # 0: Usual object or 1: Preprocessed source or 2: Assembly source.
endif()
if(EXAMPLE_ALT_OUTPUT_TYPE EQUAL 1)
  set_property(SOURCE ${GSG_BASE_DIR}/src/test_dep_scan_etc_c.c
  APPEND PROPERTY COMPILE_OPTIONS
  -output=prep=test_dep_scan_etc_c.p
  )
elseif(EXAMPLE_ALT_OUTPUT_TYPE EQUAL 2)
  set_property(SOURCE ${GSG_BASE_DIR}/src/test_dep_scan_etc_c.c
  APPEND PROPERTY COMPILE_OPTIONS
  -output=src=test_dep_scan_etc_c.s
  )
endif()

##########
endmacro()
##########

#------------------------------------------
# Note: Renesas specific flags and commands
#------------------------------------------

#set(CMAKE_LBG_FLAGS "<flag> ...")
#add_library_generate_options(<option> ...)
#target_library_generate_options(<target> [BEFORE] <INTERFACE|PUBLIC|PRIVATE> [items1...] [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
# If at least one of the above commands is done, specified options are used for Renesas Library Generator.

# Unless options other than the following are specifed, options specified for the compiler are also used
# for the library generator. But if options other than the following are specifed, options specified for
# the compiler are no longer used for the library generator and any options have to be specified by doing
# the above commands. 
# -head=<items>
# -output=<file>
# -nofloat
# -reent
# -lang=<item>
# -simple_stdio
# -secure_malloc
# -logo
# -nologo

# If `-head=` option is not included in the options for the library generator, the following is used.
# For C90
# -head=runtime,ctype,math,mathf,stdarg,stdio,stdlib,string
# For C99
# -head=runtime,ctype,math,mathf,stdarg,stdio,stdlib,string,c99_complex,fenv,inttypes,wchar,wctype
# For C++ or EC++, and C90 (Note that C++ language specification is compatible with Visual Studio 6.0)
# -head=runtime,ctype,math,mathf,stdarg,stdio,stdlib,string,ios,new,complex,cppstring
# For C++ or EC++, and C99 (Note that C++ language specification is compatible with Visual Studio 6.0)
# -head=runtime,ctype,math,mathf,stdarg,stdio,stdlib,string,ios,new,complex,cppstring,c99_complex,fenv,inttypes,wchar,wctype
# You can remove unused items from -head= list to make a generating time shorter.

# Since add_library_generate_options() and target_library_generate_options() are not CMake's native command,
# so that these commands cannot be used before enable_language() or project().

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

# If neither enable_language() nor project() activate C++ language mode, `-noprelink` is
# specified automatically.

#----------------------------------------------------
# Note: Renesas compiler options' additional behavior
#----------------------------------------------------

# Assembler's `-listfile=` can be followed by one of the following items.
# .
# ..
# <path>/
# Nothing are followed. (This is the same as followed by `.`.)
#
# Please do not use the path which includes any Japanese characters.

# Assembler's `-define=` can accept a symbol without a value. In the case, the symbol is
# regarded as being specified with 1. (i.e `-define=<symbol>=1`)

#---------------------------------------------------------------------
# Note: DebugComp, Internal and Utilities folder location of e2 studio
#---------------------------------------------------------------------

# Renesas' FAQ
#
# https://en-support.renesas.com/knowledgeBase/19891761
# https://ja-support.renesas.com/knowledgeBase/19851044
