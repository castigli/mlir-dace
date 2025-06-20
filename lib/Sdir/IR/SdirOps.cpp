//===- SdirOps.cpp - Sdir dialect ops ---------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Sdir/IR/SdirOps.h"
#include "Sdir/IR/SdirDialect.h"

#define GET_OP_CLASSES
#include "Sdir/IR/SdirOps.cpp.inc"


using namespace mlir;
using namespace mlir::sdir;

//===----------------------------------------------------------------------===//
// SdfgOp
//===----------------------------------------------------------------------===//

void SdfgOp::build(mlir::OpBuilder &builder, mlir::OperationState &state,
                   llvm::StringRef name, mlir::FunctionType type,
                   llvm::ArrayRef<mlir::NamedAttribute> attrs) {
  // FunctionOpInterface provides a convenient `build` method that will populate
  // the state of our SdfgOp, and create an entry block.
  buildWithEntryBlock(builder, state, name, type, attrs, type.getInputs());
}

mlir::ParseResult SdfgOp::parse(mlir::OpAsmParser &parser,
                                mlir::OperationState &result) {
  // Dispatch to the FunctionOpInterface provided utility method that parses the
  // function operation.
  auto buildFuncType =
      [](mlir::Builder &builder, llvm::ArrayRef<mlir::Type> argTypes,
         llvm::ArrayRef<mlir::Type> results,
         mlir::function_interface_impl::VariadicFlag,
         std::string &) { return builder.getFunctionType(argTypes, results); };

  return mlir::function_interface_impl::parseFunctionOp(
      parser, result, /*allowVariadic=*/false,
      getFunctionTypeAttrName(result.name), buildFuncType,
      getArgAttrsAttrName(result.name), getResAttrsAttrName(result.name));
}

void SdfgOp::print(mlir::OpAsmPrinter &p) {
  // Dispatch to the FunctionOpInterface provided utility method that prints the
  // function operation.
  mlir::function_interface_impl::printFunctionOp(
      p, *this, /*isVariadic=*/false, getFunctionTypeAttrName(),
      getArgAttrsAttrName(), getResAttrsAttrName());
}

//===----------------------------------------------------------------------===//
// SdfgCallOp
//===----------------------------------------------------------------------===//
void SdfgCallOp::build(mlir::OpBuilder &builder, mlir::OperationState &state,
                       StringRef callee, ArrayRef<mlir::Value> arguments) {
  // SdfgCall does not return any values, so we do not add any types to the state.
  state.addOperands(arguments);
  state.addAttribute("callee",  
    mlir::SymbolRefAttr::get(builder.getContext(), callee));
}     

/// Return the callee of the sdfg Call operation, this is required by the
/// call interface.
CallInterfaceCallable SdfgCallOp::getCallableForCallee() {
  return (*this)->getAttrOfType<SymbolRefAttr>("callee");
}

/// Set the callee for the sdfg call operation, this is required by the call
/// interface.
void SdfgCallOp::setCalleeFromCallable(CallInterfaceCallable callee) {
  (*this)->setAttr("callee", cast<SymbolRefAttr>(callee));
}

/// Get the argument operands to the called function, this is required by the
/// call interface.
Operation::operand_range SdfgCallOp::getArgOperands() { return getInputs(); }

/// Get the argument operands to the called function as a mutable range, this is
/// required by the call interface.
MutableOperandRange SdfgCallOp::getArgOperandsMutable() {
  return getInputsMutable();
}