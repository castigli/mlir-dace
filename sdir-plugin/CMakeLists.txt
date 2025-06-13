add_llvm_library(SdirPlugin
        # BUILDTREE_ONLY is only for testing purposes
        MODULE BUILDTREE_ONLY
        sdir-plugin.cpp

        DEPENDS
        MLIRSdir
        PLUGIN_TOOL
        mlir-opt

        LINK_LIBS
        MLIRSdir
        )
target_include_directories(
        SdirPlugin
        PRIVATE
        "${SDIR_BINARY_DIR}/include"
)
