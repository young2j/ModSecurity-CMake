cmake_minimum_required(VERSION 3.15)
project(libinjection)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER cc)
set(C_FLAGS
    -Wall
    -Wextra
    -Werror
    -Wno-strict-prototypes
    -pedantic
    -ansi
    -g
    -O3
    -fPIC)

# headers and sources
set(HEADERS
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_sqli.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_sqli_data.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_html5.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_xss.h)
set(SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_sqli.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_html5.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libinjection_xss.c)

# shared lib
add_library(injection SHARED ${SOURCES} ${HEADERS})
target_compile_options(injection PRIVATE ${C_FLAGS})

# static lib
add_library(libinjection.a STATIC ${SOURCES} ${HEADERS})
set_target_properties(libinjection.a PROPERTIES PREFIX "" SUFFIX "")
target_compile_options(libinjection.a PRIVATE ${C_FLAGS})
