# ##############################################################################
# ~~~
# cmake:
# ** No dependencies
#   -DDEBUG_LOGS=OFF
#   -DBUILD_PARSER=OFF
#   -DAFL_FUZZER=OFF
#   -DMUTEXT_ON_PM=OFF
#   -DBUILD_EXAMPLES=ON
#   -DBUILD_TESTS=OFF
# ** Dependencies from vcpkg manifest mode
#   -GNinja
#   -DVCPKG_MANIFEST_MODE=ON
#   -DCMAKE_TOOLCHAIN_FILE=$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake
#   -DSHOW_PKG=OFF
#   -DWITH_YAJL=OFF
#   -DWITH_GEOIP=OFF
#   -DWITH_MAXMIND=OFF
#   -DWITH_SSDEEP=OFF
#   -DWITH_CURL=OFF
#   -DWITH_YAJL=OFF
#   -DWITH_LMDB=OFF
#   -DWITH_LIBXML2=OFF
#   -DWITH_PCRE=OFF
#   -DWITH_PCRE2=OFF
#   -DWITH_LUA=OFF
# ~~~
# ##############################################################################

cmake_minimum_required(VERSION 3.15)

# ---------------------------------------------------------------------
# Project Information
# ---------------------------------------------------------------------
project(
  ModSecurity
  VERSION 3.0
  DESCRIPTION "security@modsecurity.org")

# ---------------------------------------------------------------------
# General cmake options
# ---------------------------------------------------------------------
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)
set(CMAKE_INSTALL_PREFIX /usr/local/modsecurity)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)

# ---------------------------------------------------------------------
# Set global compile options
# ---------------------------------------------------------------------
set(GLOBAL_CFLAGS "")
set(GLOBAL_CPPFLAGS -Wall -g -fPIC -O3)
set(GLOBAL_LDFLAGS "")
set(GLOBAL_DEFINITIONS "")
set(GLOBAL_INCLUDE_DIRS "")
set(GLOBAL_LINK_LIBS "")

# ---------------------------------------------------------------------
# Set module find path - find dependencies from vcpkg, system or others
# ---------------------------------------------------------------------
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# ---------------------------------------------------------------------
# Set global dirs - to further include header files and find src files
# ---------------------------------------------------------------------
set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(HEADERS_DIR ${ROOT_DIR}/headers)
set(SRC_DIR ${ROOT_DIR}/src)
set(OTHERS_DIR ${ROOT_DIR}/others)

# ---------------------------------------------------------------------
# Find modsecurity.h - generate some variables about version
# ---------------------------------------------------------------------
find_file(
  MSC_H
  NAMES modsecurity.h
  PATHS headers/modsecurity REQUIRED)

# last commit hash
execute_process(
  COMMAND git log -1 --format="%h" --abbrev-commit
  OUTPUT_VARIABLE MSC_GIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE)

# version major
execute_process(
  COMMAND
    sh -c
    "cat ${MSC_H} | grep \"define MODSECURITY_MAJOR\" | awk {'print $3'} | sed 's/\"//g'"
  OUTPUT_VARIABLE MSC_VERSION_MAJOR
  OUTPUT_STRIP_TRAILING_WHITESPACE)
# version minor
execute_process(
  COMMAND
    sh -c
    "cat ${MSC_H} | grep \"define MODSECURITY_MINOR\" | awk {'print $3'} | sed 's/\"//g'"
  OUTPUT_VARIABLE MSC_VERSION_MINOR
  OUTPUT_STRIP_TRAILING_WHITESPACE)
# version patchlevel
execute_process(
  COMMAND
    sh -c
    "cat ${MSC_H} | grep \"define MODSECURITY_PATCHLEVEL\" | awk {'print $3'} | sed 's/\"//g'"
  OUTPUT_VARIABLE MSC_VERSION_PATCHLEVEL
  OUTPUT_STRIP_TRAILING_WHITESPACE)
# tag
execute_process(
  COMMAND
    sh -c
    "cat ${MSC_H} | grep \"define MODSECURITY_TAG\" | awk {'print $3'} | sed 's/\"//g'"
  OUTPUT_VARIABLE MSC_TAG
  OUTPUT_STRIP_TRAILING_WHITESPACE)

# version git
execute_process(
  COMMAND git describe
  OUTPUT_VARIABLE MSC_VERSION_GIT
  OUTPUT_STRIP_TRAILING_WHITESPACE)

math(EXPR MSC_VERSION_C_PLUS_A "${MSC_VERSION_MAJOR} + ${MSC_VERSION_MINOR}")
set(MSC_VERSION "${MSC_VERSION_MAJOR}.${MSC_VERSION_MINOR}")
set(MSC_VERSION_WITH_PATCHLEVEL
    "${MSC_VERSION_MAJOR}.${MSC_VERSION_MINOR}.${MSC_VERSION_PATCHLEVEL}")
set(MSC_VERSION_INFO
    "${MSC_VERSION_C_PLUS_A}:${MSC_VERSION_PATCHLEVEL}:${MSC_VERSION_MINOR}")

# ---------------------------------------------------------------------
# Check for libinjection
# ---------------------------------------------------------------------
if(NOT EXISTS
   ${CMAKE_CURRENT_SOURCE_DIR}/others/libinjection/src/libinjection_html5.c)
  message(
    FATAL_ERROR
      "libInjection was not found within ModSecurity source directory.

    libInjection code is available as part of ModSecurity source code in a format
    of a git-submodule. git-submodule allow us to specify the correct version of
    libInjection and still uses the libInjection repository to download it.

    You can download libInjection using git:

     $ git submodule init
     $ git submodule update")
endif()

# Libinjection version
execute_process(
  COMMAND sh -c
          "cd ${CMAKE_CURRENT_SOURCE_DIR}/others/libinjection && git describe"
  OUTPUT_VARIABLE LIBINJECTION_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE)

# SecLang test version
execute_process(
  COMMAND
    sh -c
    "cd ${CMAKE_CURRENT_SOURCE_DIR}/test/test-cases/secrules-language-tests && git log -1 --format=\"%h\" --abbrev-commit"
  OUTPUT_VARIABLE SECLANG_TEST_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE)

# ---------------------------------------------------------------------
# Identify platform
# ---------------------------------------------------------------------
if(CMAKE_HOST_SYSTEM_NAME MATCHES "AIX")
  message("Checking platform... Identified as AIX")
  set(AIX 1)
  set(PLATFORM "AIX")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "HP-UX")
  message("Checking platform... Identified as HPUX")
  set(HPUX 1)
  set(PLATFORM "HPUX")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin")
  message("Checking platform... Identified as Macintosh OS X")
  set(MACOSX 1)
  set(PLATFORM "MacOSX")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux" OR CMAKE_HOST_SYSTEM_NAME MATCHES
                                                 "uclinux")
  message("Checking platform... Identified as Linux")
  set(LINUX 1)
  set(PLATFORM "Linux")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Solaris")
  message("Checking platform... Identified as Solaris")
  set(SOLARIS 1)
  set(PLATFORM "Solaris")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "FreeBSD")
  message("Checking platform... Identified as FreeBSD")
  set(FREEBSD 1)
  set(PLATFORM "FreeBSD")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "NetBSD")
  message("Checking platform... Identified as NetBSD")
  set(NETBSD 1)
  set(PLATFORM "NetBSD")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "OpenBSD")
  message("Checking platform... Identified as OpenBSD")
  set(OPENBSD 1)
  set(PLATFORM "OpenBSD")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "kFreeBSD")
  message("Checking platform... Identified as kFreeBSD, treating as Linux")
  set(FREEBSD 1)
  set(PLATFORM "kFreeBSD")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "DragonFly")
  message("Checking platform... Identified as DragonFlyBSD, treating as Linux")
  set(DRAGONFLY 1)
  set(PLATFORM "DragonFly")

elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "GNU")
  message("Checking platform... Identified as HURD, treating as Linux")
  set(LINUX 1)
  set(PLATFORM "HURD")

else()
  message("Unknown CANONICAL_HOST ${CMAKE_HOST_SYSTEM_NAME}")
  message(FATAL_ERROR "Unknown CANONICAL_HOST ${CMAKE_HOST_SYSTEM_NAME}")
  return()
endif()

if(NOT ${PLATFORM} STREQUAL "MacOSX" AND NOT ${PLATFORM} STREQUAL "OpenBSD")
  set(GLOBAL_LDFLAGS "${GLOBAL_LDFLAGS} -lrt")
endif()

# ---------------------------------------------------------------------
# General definition options
# ---------------------------------------------------------------------
# Debug logs
option(DEBUG_LOGS "Enable SecDebugLog feature" OFF)
if(NOT DEBUG_LOGS)
  set(GLOBAL_DEFINITIONS "${GLOBAL_DEFINITIONS};NO_LOGS=1")
endif()

# Examples
option(BUILD_EXAMPLES "Enable examples compilation (default option)" ON)

# Fuzzer
option(AFL_FUZZER "Enable afl fuzzer compilation utilities" OFF)
if(AFL_FUZZER)
  set(FUZZ_CPPFLAGS "-fsanitize=address -fsanitize-coverage=4")
  set(GLOBAL_CPPFLAGS "${GLOBAL_CPPFLAGS} ${FUZZ_CPPFLAGS}")
  set(BUILD_EXAMPLES OFF)
endif()

# Parser
option(BUILD_PARSER "Enables parser generation during the build" OFF)
if(BUILD_PARSER)
  find_program(FLEX flex)
  if(NOT FLEX)
    message(FATAL_ERROR "flex is needed to build ModSecurity")
  endif()

  find_program(BISON bison)
  if(NOT BISON)
    message(FATAL_ERROR "bison is needed to build ModSecurity")
  endif()

  find_program(YACC yacc)
  if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/gram.c)
    if(NOT YACC)
      message(FATAL_ERROR "yacc not found - unable to compile ModSecurity")
    endif()
  endif()
endif()

# Mutex
option(MUTEX_ON_PM "Treats pm operations as a critical section" OFF)
if(MUTEX_ON_PM)
  set(GLOBAL_DEFINITIONS
      "${GLOBAL_DEFINITIONS};MODSEC_MUTEX_ON_PM=1;MUTEX_ON_PM=1")
  # ?? MUTEX_ON_PM may be unused? MODSEC_MUTEX_ON_PM be used in src instead.
endif()

# Test utilities
option(BUILD_TESTS "Build test utilities" OFF)

# Package info
option(SHOW_PKG "Show dependent package information" OFF)

# ---------------------------------------------------------------------
# make check-valgrind // todo: maybe not work
# ---------------------------------------------------------------------
find_program(VALGRIND valgrind)
if(VALGRIND)
  set(VALGRIND_SUPPRESSIONS
      ${CMAKE_CURRENT_SOURCE_DIR}/test/valgrind_suppressions.txt)
  set(TEST_SUITE_SH ${CMAKE_CURRENT_SOURCE_DIR}/test/test-suite.sh)
  add_custom_target(
    check-valgrind
    COMMAND ${VALGRIND} --leak-check=full --show-leak-kinds=all
            --suppressions=${VALGRIND_SUPPRESSIONS} ${TEST_SUITE_SH})
endif()

# ---------------------------------------------------------------------
# Print a fancy summary
# ---------------------------------------------------------------------
# print package info
function(print_package pkg_name PKG_NAME)
  set(pkg_status "disabled")
  if(WITH_${PKG_NAME})
    set(pkg_status "enabled")
    set(GLOBAL_DEFINITIONS
        "${GLOBAL_DEFINITIONS};WITH_${PKG_NAME}=1"
        PARENT_SCOPE)
    if(${pkg_name}_FOUND OR ${PKG_NAME}_FOUND)
      set(LUA_INCLUDE_DIRS "${LUA_INCLUDE_DIR}")
      set(GLOBAL_INCLUDE_DIRS
          "${GLOBAL_INCLUDE_DIRS};${${PKG_NAME}_INCLUDE_DIRS}"
          PARENT_SCOPE)
      set(GLOBAL_LINK_LIBS
          "${GLOBAL_LINK_LIBS};${${PKG_NAME}_LIBRARIES}"
          PARENT_SCOPE)
    endif()
  endif()

  if(NOT ${pkg_name}_FOUND AND NOT ${PKG_NAME}_FOUND)
    message(
      "   + ${PKG_NAME}\t                                       ....not found")
    message(
      "     WITH_${PKG_NAME}=${WITH_${PKG_NAME}}\t                               ....${pkg_status}"
    )
    message(
      "   -----------------------------------------------------------------")
  else()
    message(
      "   + ${PKG_NAME}\t                                       ....found")
    message(
      "     WITH_${PKG_NAME}=${WITH_${PKG_NAME}}\t                               ....${pkg_status}"
    )
    if(SHOW_PKG)
      message("     version: ${${PKG_NAME}_VERSION_STRING}")
      message("     include: ${${PKG_NAME}_INCLUDE_DIRS}")
      message("     library: ${${PKG_NAME}_LIBRARIES}")
    endif()
    message(
      "   -----------------------------------------------------------------")
  endif()
endfunction()

message(" ")
message(
  "================================================================================"
)
message("ModSecurity - ${MSC_VERSION_GIT} for ${PLATFORM}")
message(" ")
message(" Mandatory dependencies")
message(
  "   + libInjection                                      ....${LIBINJECTION_VERSION}"
)
message(
  "   + SecLang tests                                     ....${SECLANG_TEST_VERSION}"
)

message(" ")
message(" Optional dependencies")

set(pkg_name_list
    "geoip"
    "maxmind"
    "ssdeep"
    "CURL"
    "yajl"
    "lmdb"
    "LibXml2"
    "pcre"
    "pcre2"
    "Lua")
foreach(pkg_name IN LISTS pkg_name_list)
  string(TOUPPER ${pkg_name} PKG_NAME)
  option(WITH_${PKG_NAME} "enable/disable dependency ${pkg_name}" OFF)
  find_package(${pkg_name} QUIET)
  print_package(${pkg_name} ${PKG_NAME})
endforeach()

# Other Options
message(" ")
message(" Other Options")
if(BUILD_TESTS)
  if(DEBUG_LOGS)
    message("   + BUILD_TESTS=ON")
    message(
      "     Test Utilities                                    ....enabled")
    message(
      "   -----------------------------------------------------------------")
  else()
    message("   + BUILD_TESTS=ON DEBUG_LOGS=OFF")
    message(
      "     Test Utilities                                    ....partially")
    message(
      "   -----------------------------------------------------------------")
  endif()
else()
  message("   + BUILD_TESTS=OFF")
  message("     Test Utilities                                    ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

if(DEBUG_LOGS)
  message("   + DEBUG_LOGS=ON")
  message("     SecDebugLog                                       ....enabled")
  message(
    "   -----------------------------------------------------------------")
else()
  message("   + DEBUG_LOGS=OFF")
  message("     SecDebugLog                                       ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

if(BUILD_EXAMPLES)
  message("   + BUILD_EXAMPLES=ON")
  message("     Library examples                                  ....enabled")
  message(
    "   -----------------------------------------------------------------")
else()
  message("   + BUILD_EXAMPLES=OFF")
  message("     Library examples                                  ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

if(AFL_FUZZER)
  message("   + AFL_FUZZER=ON")
  message("     Afl fuzzer                                    ....enabled")
  message("        (${FUZZ_CPPFLAGS})")
  message(
    "   -----------------------------------------------------------------")
else()
  message("   + AFL_FUZZER=OFF")
  message("     Afl fuzzer                                        ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

if(BUILD_PARSER)
  message("   + BUILD_PARSER=ON")
  message("     Building parser                                   ....enabled")
  message(
    "   -----------------------------------------------------------------")
else()
  message("   + BUILD_PARSER=OFF")
  message("     Building parser                                   ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

if(MUTEX_ON_PM)
  message("   + MUTEX_ON_PM=ON")
  message("     Treating pm operations as critical section        ....enabled")
  message(
    "   -----------------------------------------------------------------")
else()
  message("   + MUTEXT_ON_PM=OFF")
  message("     Treating pm operations as critical section        ....disabled")
  message(
    "   -----------------------------------------------------------------")
endif()

message(
  "=================================================================================="
)

if(AFL_FUZZER)
  message("WARNING: afl fuzzer was enabled. Make sure you are using the")
  message(" 'afl-clang-fast' as the compiler, otherwise the compilation")
  message("  will fail.")
  message(" ")
  message(" You can set the compiler using:")
  message(" ")
  message("  $ export CXX=afl-clang-fast++ ")
  message("  $ export CC=afl-clang-fast ")
  message(" ")
endif()

# ---------------------------------------------------------------------
# Add subdirectories
# ---------------------------------------------------------------------
add_subdirectory(${OTHERS_DIR}/libinjection)
add_subdirectory(${OTHERS_DIR}/mbedtls)
add_subdirectory(src)

if(BUILD_EXAMPLES)
  add_subdirectory(${ROOT_DIR}/examples)
endif()

# todo:
if(BUILD_TESTS)
  add_subdirectory(${ROOT_DIR}/test)
endif()
