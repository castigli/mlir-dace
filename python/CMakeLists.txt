include(AddMLIRPython)

# Specifies that all MLIR packages are co-located under the `mlir_sdir`
# top level package (the API has been embedded in a relocatable way).
# TODO: Add an upstream cmake param for this vs having a global here.
add_compile_definitions("MLIR_PYTHON_PACKAGE_PREFIX=mlir_sdir.")


################################################################################
# Sources
################################################################################

declare_mlir_python_sources(SdirPythonSources)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT SdirPythonSources
  ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/mlir_sdir"
  TD_FILE dialects/SdirOps.td
  SOURCES
    dialects/sdir_pybind11.py
    dialects/sdir_nanobind.py
  DIALECT_NAME Sdir)


declare_mlir_python_extension(SdirPythonSources.Pybind11Extension
  MODULE_NAME _SdirDialectsPybind11
  ADD_TO_PARENT SdirPythonSources
  SOURCES
    SdirExtensionPybind11.cpp
  EMBED_CAPI_LINK_LIBS
    SdirCAPI
  PYTHON_BINDINGS_LIBRARY pybind11
)

declare_mlir_python_extension(SdirPythonSources.NanobindExtension
  MODULE_NAME _SdirDialectsNanobind
  ADD_TO_PARENT SdirPythonSources
  SOURCES
    SdirExtensionNanobind.cpp
  EMBED_CAPI_LINK_LIBS
    SdirCAPI
  PYTHON_BINDINGS_LIBRARY nanobind
)


################################################################################
# Common CAPI
################################################################################

add_mlir_python_common_capi_library(SdirPythonCAPI
  INSTALL_COMPONENT SdirPythonModules
  INSTALL_DESTINATION python_packages/Sdir/mlir_sdir/_mlir_libs
  OUTPUT_DIRECTORY "${MLIR_BINARY_DIR}/python_packages/Sdir/mlir_sdir/_mlir_libs"
  RELATIVE_INSTALL_ROOT "../../../.."
  DECLARED_SOURCES
    SdirPythonSources
    # TODO: Remove this in favor of showing fine grained registration once
    # available.
    MLIRPythonExtension.RegisterEverything
    MLIRPythonSources.Core
)

################################################################################
# Instantiation of all Python modules
################################################################################

add_mlir_python_modules(SdirPythonModules
  ROOT_PREFIX "${MLIR_BINARY_DIR}/python_packages/Sdir/mlir_sdir"
  INSTALL_PREFIX "python_packages/Sdir/mlir_sdir"
  DECLARED_SOURCES
    SdirPythonSources
    # TODO: Remove this in favor of showing fine grained registration once
    # available.
    MLIRPythonExtension.RegisterEverything
    MLIRPythonSources
  COMMON_CAPI_LINK_LIBS
    SdirPythonCAPI
  )
