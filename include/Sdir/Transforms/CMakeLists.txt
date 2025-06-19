set(LLVM_TARGET_DEFINITIONS SdirPasses.td)
mlir_tablegen(SdirPasses.h.inc --gen-pass-decls)
add_public_tablegen_target(MLIRSdirPassesIncGen)
add_mlir_doc(SdirPasses SdirPasses Sdir/ -gen-pass-doc)
