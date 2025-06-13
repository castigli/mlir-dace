//===- SdirDialect.td - Sdir dialect -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SDIR_DIALECT
#define SDIR_DIALECT

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// Sdir dialect definition.
//===----------------------------------------------------------------------===//

def Sdir_Dialect : Dialect {
    let name = "sdir";
    let summary = "A sdir out-of-tree MLIR dialect.";
    let description = [{
        This dialect is an example of an out-of-tree MLIR dialect designed to
        illustrate the basic setup required to develop MLIR-based tools without
        working inside of the LLVM source tree.
    }];
    let cppNamespace = "::mlir::sdir";

    let useDefaultTypePrinterParser = 1;
    let extraClassDeclaration = [{
        void registerTypes();
    }];
}

//===----------------------------------------------------------------------===//
// Base Sdir operation definition.
//===----------------------------------------------------------------------===//

class Sdir_Op<string mnemonic, list<Trait> traits = []> :
        Op<Sdir_Dialect, mnemonic, traits>;

#endif // SDIR_DIALECT
