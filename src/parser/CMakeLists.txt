cmake_minimum_required(VERSION 3.15)
project(parser)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SRC)
add_library(modsec_parser ${SRC})
target_compile_options(modsec_parser PRIVATE ${GLOBAL_CPPFLAGS})
target_compile_definitions(modsec_parser PRIVATE ${GLOBAL_DEFINITIONS})
target_link_options(modsec_parser PRIVATE ${GLOBAL_LDFLAGS})

target_include_directories(
  modsec_parser PRIVATE ${ROOT_DIR} ${SRC_DIR} ${OTHERS_DIR} ${HEADERS_DIR}
                        ${GLOBAL_INCLUDE_DIRS})

target_link_libraries(modsec_parser PRIVATE ${GLOBAL_LINK_LIBS})
