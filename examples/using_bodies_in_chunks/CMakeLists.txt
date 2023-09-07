cmake_minimum_required(VERSION 3.15)
project(eg_body_chunks)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)

add_executable(eg_body_chunks simple_request.cc)
target_compile_options(eg_body_chunks PRIVATE ${GLOBAL_CPPFLAGS})
target_link_options(eg_body_chunks PRIVATE ${GLOBAL_LDFLAGS})
target_include_directories(eg_body_chunks PUBLIC ${HEADERS_DIR})
target_link_libraries(eg_body_chunks PUBLIC modsecurity)
