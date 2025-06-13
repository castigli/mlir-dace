//===- SdirTypes.td - Sdir dialect types -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef Sdir_TYPES
#define Sdir_TYPES

include "mlir/IR/AttrTypeBase.td"
include "Sdir/SdirDialect.td"

//===----------------------------------------------------------------------===//
// Sdir type definitions
//===----------------------------------------------------------------------===//

class Sdir_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<Sdir_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

def Sdir_CustomType : Sdir_Type<"Custom", "custom"> {
    let summary = "Sdir custom type";
    let description = "Custom type in Sdir dialect";
    let parameters = (ins StringRefParameter<"the custom value">:$value);
    let assemblyFormat = "`<` $value `>`";
}

#endif // Sdir_TYPES
