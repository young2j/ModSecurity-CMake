cmake_minimum_required(VERSION 3.15)
# ---------------------------------------------------------------------
# Project Information
# ---------------------------------------------------------------------
project(
  modsecurity
  VERSION 3.0
  DESCRIPTION "security@modsecurity.org")

# ---------------------------------------------------------------------
# check headers and configure config.h
# ---------------------------------------------------------------------
include(CheckIncludeFileCXX)
check_include_file_cxx("dlfcn.h" HAVE_DLFCN_H)
check_include_file_cxx("inttypes.h" HAVE_INTTYPES_H)
check_include_file_cxx("iostream" HAVE_IOSTREAM)
check_include_file_cxx("stdint.h" HAVE_STDINT_H)
check_include_file_cxx("stdio.h" HAVE_STDIO_H)
check_include_file_cxx("stdlib.h" HAVE_STDLIB_H)
check_include_file_cxx("string" HAVE_STRING)
check_include_file_cxx("strings.h" HAVE_STRINGS_H)
check_include_file_cxx("string.h" HAVE_STRING_H)
check_include_file_cxx("sys/stat.h" HAVE_SYS_STAT_H)
check_include_file_cxx("sys/types.h" HAVE_SYS_TYPES_H)
check_include_file_cxx("sys/utsname.h" HAVE_SYS_UTSNAME_H)
check_include_file_cxx("unistd.h" HAVE_UNISTD_H)
configure_file(config.h.in ${PROJECT_SOURCE_DIR}/config.h @ONLY)

# ---------------------------------------------------------------------
# pregenerated parser + parser sources
# ---------------------------------------------------------------------
set(EXTRA_DIST
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/location.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/position.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-parser.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-parser.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-parser.yy
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-scanner.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-scanner.ll
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/stack.hh)

# ---------------------------------------------------------------------
# headers
# ---------------------------------------------------------------------
set(MSC_HEADERS
    ${HEADERS_DIR}/modsecurity/anchored_set_variable_translation_proxy.h
    ${HEADERS_DIR}/modsecurity/anchored_set_variable.h
    ${HEADERS_DIR}/modsecurity/anchored_variable.h
    ${HEADERS_DIR}/modsecurity/audit_log.h
    ${HEADERS_DIR}/modsecurity/debug_log.h
    ${HEADERS_DIR}/modsecurity/intervention.h
    ${HEADERS_DIR}/modsecurity/modsecurity.h
    ${HEADERS_DIR}/modsecurity/rule.h
    ${HEADERS_DIR}/modsecurity/rule_marker.h
    ${HEADERS_DIR}/modsecurity/rule_unconditional.h
    ${HEADERS_DIR}/modsecurity/rule_with_actions.h
    ${HEADERS_DIR}/modsecurity/rule_with_operator.h
    ${HEADERS_DIR}/modsecurity/rules.h
    ${HEADERS_DIR}/modsecurity/rule_message.h
    ${HEADERS_DIR}/modsecurity/rules_set.h
    ${HEADERS_DIR}/modsecurity/rules_set_phases.h
    ${HEADERS_DIR}/modsecurity/rules_set_properties.h
    ${HEADERS_DIR}/modsecurity/rules_exceptions.h
    ${HEADERS_DIR}/modsecurity/transaction.h
    ${HEADERS_DIR}/modsecurity/variable_origin.h
    ${HEADERS_DIR}/modsecurity/variable_value.h)

set(COLLECTION_HEADERS ${HEADERS_DIR}/modsecurity/collection/collection.h
                       ${HEADERS_DIR}/modsecurity/collection/collections.h)

set(ACTIONS_HEADERS ${HEADERS_DIR}/modsecurity/actions/action.h)

file(
  GLOB
  NOINST_HEADERS
  ${CMAKE_CURRENT_SOURCE_DIR}/actions/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/actions/data/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/debug_log/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/writer/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/collection/backend/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/operators/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/parser/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/request_body_processor/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utils/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/variables/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/engine/*.h
  ${CMAKE_CURRENT_SOURCE_DIR}/*.h)

set(MODSEC_HEADERS ${MSC_HEADERS} ${COLLECTION_HEADERS} ${ACTIONS_HEADERS}
                   ${NOINST_HEADERS})

# ---------------------------------------------------------------------
# sources
# ---------------------------------------------------------------------
set(SRC_ENGINES ${CMAKE_CURRENT_SOURCE_DIR}/engine/lua.cc)
set(SRC_VARIABLES
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/duration.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/env.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/highest_severity.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/modsec_build.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/remote_user.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/rule.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_day.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_epoch.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_hour.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_min.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_mon.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_sec.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_wday.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/time_year.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/tx.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/variable.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/variables/xml.cc)

set(SRC_ACTIONS
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/accuracy.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/action.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/audit_log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/block.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/capture.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/chain.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/audit_log_parts.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/audit_engine.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/rule_engine.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/request_body_processor_json.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/request_body_processor_xml.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/request_body_processor_urlencoded.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/rule_remove_target_by_tag.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/rule_remove_target_by_id.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/rule_remove_by_id.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/rule_remove_by_tag.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ctl/request_body_access.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/allow.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/deny.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/drop.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/redirect.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/disruptive/pass.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/exec.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/init_col.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/log_data.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/maturity.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/msg.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/multi_match.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/no_audit_log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/no_log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/phase.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/rev.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/rule_id.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/severity.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/set_env.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/set_rsc.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/set_sid.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/set_uid.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/set_var.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/data/status.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/skip.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/skip_after.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/tag.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/base64_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/base64_encode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/base64_decode_ext.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/cmd_line.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/compress_whitespace.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/css_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/escape_seq_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/hex_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/hex_encode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/html_entity_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/js_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/length.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/lower_case.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/md5.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/none.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/normalise_path.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/normalise_path_win.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/parity_even_7bit.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/parity_odd_7bit.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/parity_zero_7bit.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/remove_comments.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/remove_comments_char.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/remove_nulls.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/remove_whitespace.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/replace_comments.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/replace_nulls.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/sha1.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/sql_hex_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/transformation.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/trim.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/trim_left.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/trim_right.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/upper_case.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/url_decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/url_decode_uni.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/url_encode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/transformations/utf8_to_unicode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/ver.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/actions/xmlns.cc)

set(SRC_OPERATORS
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/begins_with.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/contains.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/contains_word.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/detect_sqli.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/detect_xss.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/ends_with.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/eq.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/fuzzy_hash.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/ge.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/geo_lookup.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/gsblookup.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/gt.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/inspect_file.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/ip_match.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/ip_match_f.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/ip_match_from_file.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/le.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/lt.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/no_match.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/operator.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/pm.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/pm_f.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/pm_from_file.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/rbl.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/rsub.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/rx.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/rx_global.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/str_eq.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/str_match.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_byte_range.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_dtd.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_hash.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_schema.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_url_encoding.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/validate_utf8_encoding.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/verify_cc.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/verify_cpf.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/verify_ssn.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/verify_svnr.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/within.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/operators/unconditional_match.cc)

set(SRC_UTILS
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/acmp.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/base64.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/decode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/geo_lookup.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/https_client.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/ip_tree.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/md5.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/msc_tree.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/random.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/regex.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/sha1.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/string.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/system.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/utils/shared_files.cc)

set(SRC_COLLECTION
    ${CMAKE_CURRENT_SOURCE_DIR}/collection/collections.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/collection/backend/in_memory-per_process.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/collection/backend/lmdb.cc)

set(SRC_BODY_PROCESSORS
    ${CMAKE_CURRENT_SOURCE_DIR}/request_body_processor/multipart.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/request_body_processor/xml.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/request_body_processor/json.cc)

set(SRC_MODSEC
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-parser.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/seclang-scanner.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/driver.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/transaction.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/anchored_set_variable.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/anchored_variable.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/audit_log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/writer/writer.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/writer/https.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/writer/serial.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/audit_log/writer/parallel.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/modsecurity.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rules_set.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rules_set_phases.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rules_set_properties.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/debug_log/debug_log.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/debug_log/debug_log_writer.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/run_time_string.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule_unconditional.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule_with_actions.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule_with_operator.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule_message.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rule_script.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/unique_id.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/rules_exceptions.cc
    ${SRC_BODY_PROCESSORS}
    ${SRC_ACTIONS}
    ${SRC_ENGINES}
    ${SRC_COLLECTION}
    ${SRC_OPERATORS}
    ${SRC_UTILS}
    ${SRC_VARIABLES})

# ---------------------------------------------------------------------
# add target
# ---------------------------------------------------------------------
# ~~~
# for debug
# message("GLOBAL_INCLUDE_DIRS ${GLOBAL_INCLUDE_DIRS}")
# message("GLOBAL_LINK_LIBS: ${GLOBAL_LINK_LIBS}")
# message("GLOBAL_LDFLAGS: ${GLOBAL_LDFLAGS}")
# message("GLOBAL_DEFINITIONS: ${GLOBAL_DEFINITIONS}")
# message("GLOBAL_CPPFLAGS: ${GLOBAL_CPPFLAGS}")
# ~~~
add_library(modsecurity ${SRC_MODSEC} ${MODSEC_HEADERS})
target_compile_options(modsecurity PRIVATE ${GLOBAL_CPPFLAGS})
target_compile_definitions(modsecurity PRIVATE ${GLOBAL_DEFINITIONS})
target_link_options(modsecurity PRIVATE ${GLOBAL_LDFLAGS})
target_include_directories(
  modsecurity
  PUBLIC ${ROOT_DIR} ${SRC_DIR} ${OTHERS_DIR} ${HEADERS_DIR}
  PRIVATE ${GLOBAL_INCLUDE_DIRS})

target_link_libraries(
  modsecurity
  PUBLIC injection mbedtls
  PRIVATE ${GLOBAL_LINK_LIBS})

# ---------------------------------------------------------------------
# add subdirectory
# ---------------------------------------------------------------------
if(BUILD_PARSER)
  add_subdirectory(parser)
  target_link_libraries(modsecurity PUBLIC modsec_parser)
endif()
