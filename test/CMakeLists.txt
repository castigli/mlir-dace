llvm_canonicalize_cmake_booleans(
        MLIR_ENABLE_BINDINGS_PYTHON
)

configure_lit_site_cfg(
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
        ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
        MAIN_CONFIG
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set(SDIR_TEST_DEPENDS
        FileCheck count not
        sdir-capi-test
        sdir-opt
        sdir-translate
        SdirPlugin
        )
if(MLIR_ENABLE_BINDINGS_PYTHON)
  list(APPEND SDIR_TEST_DEPENDS SdirPythonModules)
endif()

add_lit_testsuite(check-sdir "Running the sdir regression tests"
        ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${SDIR_TEST_DEPENDS}
        )
set_target_properties(check-sdir PROPERTIES FOLDER "Tests")

add_lit_testsuites(sdir ${CMAKE_CURRENT_SOURCE_DIR} DEPENDS ${SDIR_TEST_DEPENDS})

add_subdirectory(CAPI)
