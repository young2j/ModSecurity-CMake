cmake_minimum_required(VERSION 3.15)
project(mbedtls)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SRC)
add_library(mbedtls ${SRC})
target_include_directories(mbedtls PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_compile_definitions(
  mbedtls
  PUBLIC MBEDTLS_CONFIG_FILE="${CMAKE_CURRENT_SOURCE_DIR}/mbed-tls-config.h")
