add_mlir_dialect_library(MLIRSdirTransforms
        SdirPasses.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Sdir

        DEPENDS
        MLIRSdirOpsIncGen
        MLIRSdirPassesIncGen

        LINK_LIBS PUBLIC
        MLIRIR
        MLIRInferTypeOpInterface
        MLIRFuncDialect
        )