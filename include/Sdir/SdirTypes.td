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
include "mlir/IR/BuiltinTypeInterfaces.td"
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


//===----------------------------------------------------------------------===//
// ArrayType
//===----------------------------------------------------------------------===//

def Sdir_ArrayType : Sdir_Type<"Array", "array", [ShapedTypeInterface]> {
  let summary = "ND bufferized tensor";
  let description = [{
    Arrays reprensent bufferized containers similarly to `memrefs`. `#layout` and 
    `#memory_space` are optional attributes that defaults to right major and CPU 
    main memory.
    The key difference with `memrefs` is that unranked shapes are not allowed and 
    unknown dimensions that are not binded to symbols assume unused symbols
    Unset dimensions have the value `ShapedType::kDynamic`.

    Example:

        ```mlir
        !sdir.array <1x1xf64, #layout-specifier, #memory_space>
        ```


    /// TODO, limit allowed types
  }];

  let parameters = (ins
    ArrayRefParameter<"int64_t">:$shape,
    "Type":$elementType,
    "MemRefLayoutAttrInterface":$layout,
    "Attribute":$memorySpace
  );

  let extraClassDeclaration = [{
    using ShapedType::Trait<ArrayType>::getElementTypeBitWidth;
    using ShapedType::Trait<ArrayType>::getRank;
    using ShapedType::Trait<ArrayType>::getNumElements;
    using ShapedType::Trait<ArrayType>::isDynamicDim;
    using ShapedType::Trait<ArrayType>::hasStaticShape;
    using ShapedType::Trait<ArrayType>::getNumDynamicDims;
    using ShapedType::Trait<ArrayType>::getDimSize;
    using ShapedType::Trait<ArrayType>::getDynamicDimIndex;

    /// Returns if this type is ranked (always true).
    bool hasRank() const { return true; }

    /// Clone view.
    ArrayType cloneWith(std::optional<ArrayRef<int64_t>> shape,
                         Type elementType) const;
  }];

  // let skipDefaultBuilders = 1;
  // let genVerifyDecl = 1;
  // let genStorageClass = 0;

  // let builders = [
  //   TypeBuilderWithInferredContext<(ins
  //       "llvm::ArrayRef<int64_t>":$shape,
  //       "mlir::Type":$elementType,
  //       "Attribute":$encoding), [{
  //     return get(elementType.getContext(), shape, elementType, encoding, ShapedType::kDynamic);
  //   }]>,
  //   TypeBuilderWithInferredContext<(ins
  //       "llvm::ArrayRef<int64_t>":$shape,
  //       "mlir::Type":$elementType,
  //       "Attribute":$encoding,
  //       "int64_t":$lds), [{
  //     return get(elementType.getContext(), shape, elementType, encoding, lds);
  //   }]>
  // ];

  let hasCustomAssemblyFormat = 1;
}




#endif // Sdir_TYPES
