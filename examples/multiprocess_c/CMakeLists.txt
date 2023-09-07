cmake_minimum_required(VERSION 3.15)
project(eg_read)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER cc)

add_executable(eg_multi_c multi.c)
target_compile_options(eg_multi_c PRIVATE ${GLOBAL_CPPFLAGS} ${GLOBAL_CFLAGS})
target_link_options(eg_multi_c PRIVATE ${GLOBAL_LDFLAGS})
target_include_directories(eg_multi_c PUBLIC ${HEADERS_DIR})
target_link_libraries(eg_multi_c PUBLIC modsecurity pthread m)
