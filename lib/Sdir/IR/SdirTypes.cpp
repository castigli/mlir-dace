//===- SdirTypes.cpp - Sdir dialect types -----------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Sdir/IR/SdirTypes.h"

#include "Sdir/IR/SdirDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributeInterfaces.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir::sdir;

#define GET_TYPEDEF_CLASSES
#include "Sdir/IR/SdirOpsTypes.cpp.inc"

void SdirDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "Sdir/IR/SdirOpsTypes.cpp.inc"
      >();
}


//===----------------------------------------------------------------------===//
// ArrayType
//===----------------------------------------------------------------------===//

ArrayType ArrayType::cloneWith(std::optional<ArrayRef<int64_t>> shape,
                             Type elementType) const {
  return ArrayType::get(getContext(), getShape(), elementType, getLayout(),
                        getMemorySpace());
}

mlir::Type ArrayType::parse(AsmParser &parser) {
  // Parse '<'.
  if (parser.parseLess())
    return nullptr;
  // Parse the size and elementType.
  SmallVector<int64_t> shape;
  Type elementType;
  if (parser.parseDimensionList(shape, /*allowDynamic=*/true) ||
      parser.parseType(elementType))
    return nullptr;

  // Parse optional layout / memory space
  MemRefLayoutAttrInterface layout;
  Attribute memorySpace;
  if (::mlir::succeeded(parser.parseOptionalComma())) {
    Attribute attr;
    if (parser.parseAttribute(attr)) {
      parser.emitError(parser.getCurrentLocation(),
                              "expected layout or memory space attribute");
      return nullptr;
    }
    // Check if the attribute is a MemRefLayoutAttrInterface.
    if (auto memRefLayout = llvm::dyn_cast<MemRefLayoutAttrInterface>(attr)) {
      layout = memRefLayout;
      // If it is check for optional memory space.
      if (::mlir::succeeded(parser.parseOptionalComma())) {
        // If we parsed a layout, we expect a memory space next.
        if (parser.parseAttribute(memorySpace))
          return nullptr;
      }
    } else {
      memorySpace = attr;
    }
  }

  // Parse '>'.
  if (parser.parseGreater())
    return nullptr;

  return ArrayType::get(parser.getContext(), shape, elementType, layout,
                         memorySpace);
}


void ArrayType::print(AsmPrinter &printer) const {
  printer << "<";
  for (int64_t dim : getShape()) {
    if (dim == ShapedType::kDynamic) {
      printer << '?';
    } else {
      printer << dim;
    }
    printer << 'x';
  }
  printer << getElementType();


  MemRefLayoutAttrInterface layout = getLayout();
  if (layout) {
    if (!llvm::isa<AffineMapAttr>(layout) || !layout.isIdentity()) {
      printer << ", ";
      printer.printAttribute(getLayout());
    }
  }
  if (getMemorySpace()) {
    printer << ", ";
    if (auto memSpaceInt = llvm::dyn_cast<IntegerAttr>(getMemorySpace())) {
      printer << memSpaceInt.getValue().getSExtValue();
    } else {
      // Print the memory space attribute.
      printer.printAttribute(getMemorySpace());
    }
  }
  printer << '>';
}