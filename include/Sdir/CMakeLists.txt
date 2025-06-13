add_mlir_dialect(SdirOps sdir)
add_mlir_doc(SdirDialect SdirDialect Sdir/ -gen-dialect-doc)
add_mlir_doc(SdirOps SdirOps Sdir/ -gen-op-doc)

set(LLVM_TARGET_DEFINITIONS SdirPasses.td)
mlir_tablegen(SdirPasses.h.inc --gen-pass-decls)
add_public_tablegen_target(MLIRSdirPassesIncGen)
