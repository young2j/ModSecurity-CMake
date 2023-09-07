cmake_minimum_required(VERSION 3.15)
project(eg_read)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)

add_executable(eg_read_logs_offset read.cc)
target_compile_options(eg_read_logs_offset PRIVATE ${GLOBAL_CPPFLAGS})
target_link_options(eg_read_logs_offset PRIVATE ${GLOBAL_LDFLAGS})
target_include_directories(eg_read_logs_offset PUBLIC ${HEADERS_DIR})
target_link_libraries(eg_read_logs_offset PUBLIC modsecurity pthread m)
