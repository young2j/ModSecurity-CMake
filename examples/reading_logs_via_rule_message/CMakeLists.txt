cmake_minimum_required(VERSION 3.15)
project(eg_read)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)

add_executable(eg_read_logs_rule simple_request.cc)
target_compile_options(eg_read_logs_rule PRIVATE ${GLOBAL_CPPFLAGS})
target_link_options(eg_read_logs_rule PRIVATE ${GLOBAL_LDFLAGS})
target_include_directories(eg_read_logs_rule PUBLIC ${HEADERS_DIR} ${ROOT_DIR})
target_link_libraries(eg_read_logs_rule PUBLIC modsecurity pthread m)
