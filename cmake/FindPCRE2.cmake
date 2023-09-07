# 检查当前的CMake版本
cmake_minimum_required(VERSION 3.15)

# 查找软件包的头文件
file(GLOB
  PCRE2_INCLUDE_DIR
  NAMES pcre2*.h
  PATHS ${CMAKE_PREFIX_PATH}/include)

# 查找软件包的库文件
find_library(
  PCRE2_LIBRARY
  NAMES pcre2 pcre2-8 pcre2-16 pcre2-32 pcre2-posix
  PATHS ${CMAKE_PREFIX_PATH}/lib)
find_library(
  PCRE2_LIBRARY_DEBUG
  NAMES pcre2 pcre2-8 pcre2-16 pcre2-32 pcre2-posix
  PATHS ${CMAKE_PREFIX_PATH}/debug/lib)
include(SelectLibraryConfigurations)
select_library_configurations(PCRE2)

set(PCRE2_VERSION "10.42")
set(PCRE2_VERSION_STRING ${PCRE2_VERSION})

# 检查是否找到软件包
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  pcre2
  FOUND_VAR pcre2_FOUND
  REQUIRED_VARS PCRE2_LIBRARY PCRE2_INCLUDE_DIR
  VERSION_VAR PCRE2_VERSION)

# 导出变量以供使用该模块的项目使用
if(pcre2_FOUND)
  set(PCRE2_INCLUDE_DIRS ${PCRE2_INCLUDE_DIR})
  set(PCRE2_LIBRARIES ${PCRE2_LIBRARY})
endif()

mark_as_advanced(PCRE2_INCLUDE_DIR PCRE2_LIBRARY)