add_llvm_library(SdirPlugin
        # BUILDTREE_ONLY is only for testing purposes
        MODULE BUILDTREE_ONLY
        sdir-plugin.cpp

        DEPENDS
        MLIRSdirIR
        MLIRSdirTransforms
        PLUGIN_TOOL
        mlir-opt

        LINK_LIBS
        MLIRSdirIR
        MLIRSdirTransforms
        )
target_include_directories(
        SdirPlugin
        PRIVATE
        "${SDIR_BINARY_DIR}/include"
)
