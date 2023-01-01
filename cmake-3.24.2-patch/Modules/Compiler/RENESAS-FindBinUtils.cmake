# This file is included as following.
#
# Modules/CMakeDetermineCCompiler.cmake#
#
#   set(_CMAKE_PROCESSING_LANGUAGE "C")
#   include(CMakeFindBinUtils)
#   include(Compiler/${CMAKE_C_COMPILER_ID}-FindBinUtils OPTIONAL)
#   unset(_CMAKE_PROCESSING_LANGUAGE)
#
# Modules/CMakeDetermineCXXCompiler.cmake
#
#   set(_CMAKE_PROCESSING_LANGUAGE "CXX")
#   include(CMakeFindBinUtils)
#   include(Compiler/${CMAKE_CXX_COMPILER_ID}-FindBinUtils OPTIONAL)
#   unset(_CMAKE_PROCESSING_LANGUAGE)
#
# Modules/CMakeDetermineASMCompiler.cmake
#
#   set(_CMAKE_PROCESSING_LANGUAGE "ASM")
#   include(CMakeFindBinUtils)
#   include(Compiler/${CMAKE_ASM${ASM_DIALECT}_COMPILER_ID}-FindBinUtils OPTIONAL)
#   unset(_CMAKE_PROCESSING_LANGUAGE)
#

# FIXME: Clean up the source code.

## __resolve_tool_path(CMAKE_LINKER "${_CMAKE_TOOLCHAIN_LOCATION}" "Default Linker")
## __resolve_tool_path(CMAKE_MT     "${_CMAKE_TOOLCHAIN_LOCATION}" "Default Manifest Tool")

set(_CMAKE_TOOL_VARS "")

# if it's the MS C/CXX compiler, search for link
if(("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_SIMULATE_ID}" STREQUAL "xMSVC" AND
   ("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_FRONTEND_VARIANT}" STREQUAL "xMSVC"
    OR NOT "x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xClang"))
   OR "x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xMSVC"
   OR (CMAKE_HOST_WIN32 AND "x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xPGI")
   OR (CMAKE_HOST_WIN32 AND "x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xNVIDIA")
   OR (CMAKE_HOST_WIN32 AND "x${_CMAKE_PROCESSING_LANGUAGE}" STREQUAL "xISPC")
   OR (CMAKE_GENERATOR MATCHES "Visual Studio"
       AND NOT CMAKE_VS_PLATFORM_NAME STREQUAL "Tegra-Android"))

##  # Start with the canonical names.
##  set(_CMAKE_LINKER_NAMES "link")
##  set(_CMAKE_AR_NAMES "lib")
##  set(_CMAKE_MT_NAMES "mt")
##
##  # Prepend toolchain-specific names.
##  if("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xClang")
##    set(_CMAKE_NM_NAMES "llvm-nm" "nm")
##    list(PREPEND _CMAKE_AR_NAMES "llvm-lib")
##    list(PREPEND _CMAKE_MT_NAMES "llvm-mt")
##    list(PREPEND _CMAKE_LINKER_NAMES "lld-link")
##    list(APPEND _CMAKE_TOOL_VARS NM)
##  elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL "xIntel")
##    list(PREPEND _CMAKE_AR_NAMES "xilib")
##    list(PREPEND _CMAKE_LINKER_NAMES "xilink")
##  endif()
##
##  list(APPEND _CMAKE_TOOL_VARS LINKER MT AR)

elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" MATCHES "^x(Open)?Watcom$")
##  set(_CMAKE_LINKER_NAMES "wlink")
##  set(_CMAKE_AR_NAMES "wlib")
##  list(APPEND _CMAKE_TOOL_VARS LINKER AR)

elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" MATCHES "^xIAR$")
##  # Small helper declaring an IAR tool (e.g. linker) to avoid repeating the same idiom every time
##  macro(__append_IAR_tool TOOL_VAR NAME)
##    set(_CMAKE_${TOOL_VAR}_NAMES "${NAME}" "${NAME}.exe")
##    list(APPEND _CMAKE_TOOL_VARS ${TOOL_VAR})
##  endmacro()
##
##  # Resolve hint path from an IAR compiler
##  function(__resolve_IAR_hints COMPILER RESULT)
##    get_filename_component(_CMAKE_IAR_HINT "${COMPILER}" REALPATH)
##    get_filename_component(_CMAKE_IAR_HINT "${_CMAKE_IAR_HINT}" DIRECTORY)
##    list(APPEND _IAR_HINTS "${_CMAKE_IAR_HINT}")
##
##    get_filename_component(_CMAKE_IAR_HINT "${COMPILER}" DIRECTORY)
##    list(APPEND _IAR_HINTS "${_CMAKE_IAR_HINT}")
##
##    set(${RESULT} "${_IAR_HINTS}" PARENT_SCOPE)
##  endfunction()
##
##  __resolve_IAR_hints("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER}" _CMAKE_TOOLCHAIN_LOCATION)
##  set(_CMAKE_IAR_ITOOLS "ARM" "RX" "RH850" "RL78" "RISCV" "RISC-V" "STM8")
##  set(_CMAKE_IAR_XTOOLS "AVR" "MSP430" "V850" "8051")
##
##  if("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" IN_LIST _CMAKE_IAR_ITOOLS)
##    string(TOLOWER "${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" _CMAKE_IAR_LOWER_ARCHITECTURE_ID)
##
##    __append_IAR_tool(AR "iarchive")
##    __append_IAR_tool(LINKER "ilink${_CMAKE_IAR_LOWER_ARCHITECTURE_ID}")
##
##    __append_IAR_tool(IAR_ELFDUMP "ielfdump${_CMAKE_IAR_LOWER_ARCHITECTURE_ID}")
##    __append_IAR_tool(IAR_ELFTOOL "ielftool")
##    __append_IAR_tool(IAR_OBJMANIP "iobjmanip")
##    __append_IAR_tool(IAR_SYMEXPORT "isymexport")
##
##    unset(_CMAKE_IAR_LOWER_ARCHITECTURE_ID)
##
##  elseif("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" IN_LIST _CMAKE_IAR_XTOOLS)
##    __append_IAR_tool(AR "xar")
##    __append_IAR_tool(LINKER "xlink")
##
##  else()
##    message(FATAL_ERROR "Failed to find linker and librarian for ${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID} on ${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}.")
##  endif()
##
##  unset(_CMAKE_IAR_ITOOLS)
##  unset(_CMAKE_IAR_XTOOLS)

elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" MATCHES "^xRENESAS$")
  # Small helper declaring RENESAS tools (e.g. libgen, linker, etc) to avoid repeating the same idiom every time
  macro(__append_RENESAS_tool TOOL_VAR NAME)
    set(_CMAKE_${TOOL_VAR}_NAMES "${NAME}" "${NAME}.exe")
    list(APPEND _CMAKE_TOOL_VARS ${TOOL_VAR})
  endmacro()

  # Resolve hint path from an RENESAS compiler
  function(__resolve_RENESAS_hints COMPILER RESULT)
    get_filename_component(_CMAKE_RENESAS_HINT "${COMPILER}" REALPATH)
    get_filename_component(_CMAKE_RENESAS_HINT "${_CMAKE_RENESAS_HINT}" DIRECTORY)
    list(APPEND _RENESAS_HINTS "${_CMAKE_RENESAS_HINT}")

    get_filename_component(_CMAKE_RENESAS_HINT "${COMPILER}" DIRECTORY)
    list(APPEND _RENESAS_HINTS "${_CMAKE_RENESAS_HINT}")

    find_program(_CMAKE_RENESAS_XCONVERTER NAMES "renesas_cc_converter" "renesas_cc_converter.exe")
    get_filename_component(_CMAKE_RENESAS_XCONVERTER_HINT "${_CMAKE_RENESAS_XCONVERTER}" DIRECTORY)
    list(APPEND _RENESAS_HINTS "${_CMAKE_RENESAS_XCONVERTER_HINT}")

    set(${RESULT} "${_RENESAS_HINTS}" PARENT_SCOPE)
  endfunction()

  __resolve_RENESAS_hints("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER}" _CMAKE_TOOLCHAIN_LOCATION)

  # FIXME: Is this usefull? (This is moved from RENESAS.cmake.)
  macro(__compiler_set_path_renesas lang c_compiler cxx_compiler asm_compiler linker)
    #if((NOT CMAKE_CXX_COMPILER) AND (NOT "x${cxx_compiler}" STREQUAL "x"))
    #  set(CMAKE_CXX_COMPILER ${_CMAKE_TOOLCHAIN_LOCATION}/${cxx_compiler})
    #endif()
    #if(NOT CMAKE_C_COMPILER)
    #  set(CMAKE_C_COMPILER ${_CMAKE_TOOLCHAIN_LOCATION}/${c_compiler})
    #endif()
    #if(NOT CMAKE_ASM${ASM_DIALECT}_COMPILER)
    #  set(CMAKE_ASM{ASM_DIALECT}_COMPILER ${_CMAKE_TOOLCHAIN_LOCATION}/${asm_compiler})
    #endif()
    #set(CMAKE_LINKER "${_CMAKE_TOOLCHAIN_LOCATION}/${linker}")
    message("DEBUG: Language ${lang}")
    message("DEBUG: C      = ${CMAKE_C_COMPILER}")
    message("DEBUG: CXX    = ${CMAKE_CXX_COMPILER}")
    message("DEBUG: ASM    = ${CMAKE_ASM${ASM_DIALECT}_COMPILER}")
    message("DEBUG: LINKER = ${CMAKE_LINKER}")
  endmacro()

  # FIXME: Is this usefull? (This is moved from RENESAS.cmake.)
  #if(CMAKE_${lang}_COMPILER_ARCHITECTURE_ID STREQUAL "RX")
  #  __compiler_set_path_renesas(${lang} ccrx ccrx asrx rlink)
  #elseif(CMAKE_${lang}_COMPILER_ARCHITECTURE_ID STREQUAL "RL78")
  #  __compiler_set_path_renesas(${lang} ccrl "" asrl rlink)
  #elseif(CMAKE_${lang}_COMPILER_ARCHITECTURE_ID STREQUAL "RH850")
  #  __compiler_set_path_renesas(${lang} ccrh "" asrh rlink)
  #endif()

  if("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" STREQUAL "xRX")
    if((NOT CMAKE_CXX_COMPILER) AND CMAKE_C_COMPILER)
      set(CMAKE_CXX_COMPILER ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1})
    endif()
    if((NOT CMAKE_CXX_FLAGS) AND CMAKE_C_FLAGS)
      set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS})
      string(REGEX REPLACE "^(|.* )-lang=[^ ]* *" "\\1" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
    endif()

    if((NOT CMAKE_C_COMPILER) AND CMAKE_CXX_COMPILER)
      set(CMAKE_C_COMPILER ${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1})
    endif()
    if((NOT CMAKE_C_FLAGS) AND CMAKE_CXX_FLAGS)
      set(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS})
      string(REGEX REPLACE "^(|.* )-lang=[^ ]* *" "\\1" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
      string(REGEX REPLACE "^(|.* )-rtti=[^ ]* *" "\\1" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
      string(REGEX REPLACE "^(|.* )-exception *"  "\\1" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
    endif()

    if(NOT DEFINED CMAKE_ASM${ASM_DIALECT}_COMPILER)
      if(CMAKE_C_COMPILER MATCHES "^(.*/)ccrx(\\.exe)?$")
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER ${CMAKE_MATCH_1}asrx${CMAKE_MATCH_2} ${CMAKE_C_COMPILER_ARG1})
      elseif(CMAKE_CXX_COMPILER MATCHES "^(.*/)ccrx(\\.exe)?$")
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER ${CMAKE_MATCH_1}asrx${CMAKE_MATCH_2} ${CMAKE_CXX_COMPILER_ARG1})
      else()
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER asrx ${CMAKE_C_COMPILER_ARG1})
      endif()
    endif()

    __append_RENESAS_tool(RENESAS_LIBRARY_GENERATOR lbgrx)
    __append_RENESAS_tool(RENESAS_XCONVERTER renesas_cc_converter)

  elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" STREQUAL "xRL78")
    # FIXME: Define function or macro and use it.
    if(NOT DEFINED CMAKE_ASM${ASM_DIALECT}_COMPILER)
      if(CMAKE_C_COMPILER MATCHES "^(.*/)ccrl(\\.exe)?$")
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER ${CMAKE_MATCH_1}asrl${CMAKE_MATCH_2} ${CMAKE_C_COMPILER_ARG1})
      else()
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER asrl ${CMAKE_C_COMPILER_ARG1})
      endif()
    endif()

    __append_RENESAS_tool(RENESAS_XCONVERTER renesas_cc_converter)

  elseif("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID}" STREQUAL "xRH850")
    # FIXME: Define function or macro and use it.
    if(NOT DEFINED CMAKE_ASM${ASM_DIALECT}_COMPILER)
      if(CMAKE_C_COMPILER MATCHES "^(.*/)ccrh(\\.exe)?$")
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER ${CMAKE_MATCH_1}asrh${CMAKE_MATCH_2} ${CMAKE_C_COMPILER_ARG1})
      else()
        set(CMAKE_ASM${ASM_DIALECT}_COMPILER asrh ${CMAKE_C_COMPILER_ARG1})
      endif()
    endif()

    #__append_RENESAS_tool(RENESAS_XCONVERTER renesas_cc_converter) # Do not append the tool in case of RH850 as of today.

  else()
    message(FATAL_ERROR "CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ARCHITECTURE_ID not detected. This should be automatic.")
  endif()

  #__append_RENESAS_tool(LINKER rlink)

# in all other cases search for ar, ranlib, etc.
else()
##  if(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN)
##    set(_CMAKE_TOOLCHAIN_LOCATION ${_CMAKE_TOOLCHAIN_LOCATION} ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN}/bin)
##  endif()
##  if(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN)
##    set(_CMAKE_TOOLCHAIN_LOCATION ${_CMAKE_TOOLCHAIN_LOCATION} ${CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN}/bin)
##  endif()
##
##  # Start with the canonical names.
##  set(_CMAKE_AR_NAMES "ar")
##  set(_CMAKE_RANLIB_NAMES "ranlib")
##  set(_CMAKE_STRIP_NAMES "strip")
##  set(_CMAKE_LINKER_NAMES "ld")
##  set(_CMAKE_NM_NAMES "nm")
##  set(_CMAKE_OBJDUMP_NAMES "objdump")
##  set(_CMAKE_OBJCOPY_NAMES "objcopy")
##  set(_CMAKE_READELF_NAMES "readelf")
##  set(_CMAKE_DLLTOOL_NAMES "dlltool")
##  set(_CMAKE_ADDR2LINE_NAMES "addr2line")
##
##  # Prepend toolchain-specific names.
##  if("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL Clang)
##    if("x${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_SIMULATE_ID}" STREQUAL "xMSVC")
##      list(PREPEND _CMAKE_LINKER_NAMES "lld-link")
##    else()
##      list(PREPEND _CMAKE_LINKER_NAMES "ld.lld")
##    endif()
##    if(NOT APPLE)
##      # llvm-ar does not generate a symbol table that the Apple ld64 linker accepts.
##      list(PREPEND _CMAKE_AR_NAMES "llvm-ar")
##    endif()
##    list(PREPEND _CMAKE_RANLIB_NAMES "llvm-ranlib")
##    if("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_VERSION}" VERSION_GREATER_EQUAL 11)
##      # llvm-strip versions prior to 11 require additional flags we do not yet add.
##      list(PREPEND _CMAKE_STRIP_NAMES "llvm-strip")
##    endif()
##    list(PREPEND _CMAKE_NM_NAMES "llvm-nm")
##    if("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_VERSION}" VERSION_GREATER_EQUAL 9)
##      # llvm-objdump versions prior to 9 did not support everything we need.
##      list(PREPEND _CMAKE_OBJDUMP_NAMES "llvm-objdump")
##    endif()
##    list(PREPEND _CMAKE_OBJCOPY_NAMES "llvm-objcopy")
##    list(PREPEND _CMAKE_READELF_NAMES "llvm-readelf")
##    list(PREPEND _CMAKE_DLLTOOL_NAMES "llvm-dlltool")
##    list(PREPEND _CMAKE_ADDR2LINE_NAMES "llvm-addr2line")
##  elseif("${CMAKE_${_CMAKE_PROCESSING_LANGUAGE}_COMPILER_ID}" STREQUAL ARMClang)
##    list(PREPEND _CMAKE_AR_NAMES "armar")
##    list(PREPEND _CMAKE_LINKER_NAMES "armlink")
##  endif()
##
##  list(APPEND _CMAKE_TOOL_VARS AR RANLIB STRIP LINKER NM OBJDUMP OBJCOPY READELF DLLTOOL ADDR2LINE)
endif()

foreach(_CMAKE_TOOL IN LISTS _CMAKE_TOOL_VARS)
  # Build the final list of prefixed/suffixed names.
  set(_CMAKE_${_CMAKE_TOOL}_FIND_NAMES "")
  foreach(_CMAKE_TOOL_NAME IN LISTS _CMAKE_${_CMAKE_TOOL}_NAMES)
    list(APPEND _CMAKE_${_CMAKE_TOOL}_FIND_NAMES
      ${_CMAKE_TOOLCHAIN_PREFIX}${_CMAKE_TOOL_NAME}${_CMAKE_TOOLCHAIN_SUFFIX}
      ${_CMAKE_TOOLCHAIN_PREFIX}${_CMAKE_TOOL_NAME}
      ${_CMAKE_TOOL_NAME}${_CMAKE_TOOLCHAIN_SUFFIX}
      ${_CMAKE_TOOL_NAME}
      )
  endforeach()
  list(REMOVE_DUPLICATES _CMAKE_${_CMAKE_TOOL}_FIND_NAMES)

  # FIXME: Generate error if not found thouth specified especially regarding renesas_cc_converter.

  find_program(CMAKE_${_CMAKE_TOOL} NAMES ${_CMAKE_${_CMAKE_TOOL}_FIND_NAMES} HINTS ${_CMAKE_TOOLCHAIN_LOCATION} NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH)
  unset(_CMAKE_${_CMAKE_TOOL}_FIND_NAMES)
endforeach()

if(NOT CMAKE_RANLIB)
    set(CMAKE_RANLIB : CACHE INTERNAL "noop for ranlib")
endif()


##if(CMAKE_PLATFORM_HAS_INSTALLNAME)
##  find_program(CMAKE_INSTALL_NAME_TOOL NAMES ${_CMAKE_TOOLCHAIN_PREFIX}install_name_tool HINTS ${_CMAKE_TOOLCHAIN_LOCATION} NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH)
##
##  if(NOT CMAKE_INSTALL_NAME_TOOL)
##    message(FATAL_ERROR "Could not find install_name_tool, please check your installation.")
##  endif()
##
##  list(APPEND _CMAKE_TOOL_VARS INSTALL_NAME_TOOL)
##endif()

# Mark any tool cache entries as advanced.
foreach(_CMAKE_TOOL IN LISTS _CMAKE_TOOL_VARS)
  get_property(_CMAKE_TOOL_CACHED CACHE CMAKE_${_CMAKE_TOOL} PROPERTY TYPE)
  if(_CMAKE_TOOL_CACHED)
    mark_as_advanced(CMAKE_${_CMAKE_TOOL})
  endif()
  unset(_CMAKE_${_CMAKE_TOOL}_NAMES)
endforeach()
unset(_CMAKE_TOOL_VARS)
unset(_CMAKE_TOOL_CACHED)
unset(_CMAKE_TOOL_NAME)
unset(_CMAKE_TOOL)

