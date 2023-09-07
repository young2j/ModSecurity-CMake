# 检查当前的CMake版本
cmake_minimum_required(VERSION 3.15)

# 查找软件包的头文件
file(GLOB
  PCRE_INCLUDE_DIR
  NAMES pcre*.h
  PATHS ${CMAKE_PREFIX_PATH}/include)

# 查找软件包的库文件
find_library(
  PCRE_LIBRARY
  NAMES pcre pcre16 pcre32 pcre-posix
  PATHS ${CMAKE_PREFIX_PATH}/lib)
find_library(
  PCRE_LIBRARY_DEBUG
  NAMES pcre pcre16 pcre32 pcre-posix
  PATHS ${CMAKE_PREFIX_PATH}/debug/lib)
include(SelectLibraryConfigurations)
select_library_configurations(PCRE)

set(PCRE_VERSION "8.45#5")
set(PCRE_VERSION_STRING ${PCRE_VERSION})

# 检查是否找到软件包
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  pcre
  FOUND_VAR pcre_FOUND
  REQUIRED_VARS PCRE_LIBRARY PCRE_INCLUDE_DIR
  VERSION_VAR PCRE_VERSION)

# 导出变量以供使用该模块的项目使用
if(pcre_FOUND)
  set(PCRE_INCLUDE_DIRS ${PCRE_INCLUDE_DIR})
  set(PCRE_LIBRARIES ${PCRE_LIBRARY})
endif()

mark_as_advanced(PCRE_INCLUDE_DIR PCRE_LIBRARY)