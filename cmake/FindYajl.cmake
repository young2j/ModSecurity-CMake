# 检查当前的CMake版本
cmake_minimum_required(VERSION 3.15)

# 查找软件包的头文件
find_path(
  YAJL_INCLUDE_DIR
  NAMES yajl
  PATHS ${CMAKE_PREFIX_PATH}/include)

# 查找软件包的库文件
find_library(
  YAJL_LIBRARY
  NAMES yajl_s yajl
  PATHS ${CMAKE_PREFIX_PATH}/lib)
find_library(
  YAJL_LIBRARY_DEBUG
  NAMES yajl_s yajl
  PATHS ${CMAKE_PREFIX_PATH}/debug/lib)
include(SelectLibraryConfigurations)
select_library_configurations(YAJL)

set(YAJL_VERSION "2.1.0")
set(YAJL_VERSION_STRING ${YAJL_VERSION})

# 检查是否找到软件包
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  yajl
  FOUND_VAR yajl_FOUND
  REQUIRED_VARS YAJL_LIBRARY YAJL_INCLUDE_DIR
  VERSION_VAR YAJL_VERSION)

# 导出变量以供使用该模块的项目使用
if(yajl_FOUND)
  set(YAJL_INCLUDE_DIRS ${YAJL_INCLUDE_DIR})
  set(YAJL_LIBRARIES ${YAJL_LIBRARY})
endif()

mark_as_advanced(YAJL_INCLUDE_DIR YAJL_LIBRARY)
