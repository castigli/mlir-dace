//===- SdirDialect.cpp - Sdir dialect ---------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Sdir/IR/SdirDialect.h"
#include "Sdir/IR/SdirOps.h"
#include "Sdir/IR/SdirTypes.h"

#include "mlir/Transforms/InliningUtils.h"

using namespace mlir;
using namespace mlir::sdir;

#include "Sdir/IR/SdirOpsDialect.cpp.inc"

//===----------------------------------------------------------------------===//
// SdirInlinerInterface
//===----------------------------------------------------------------------===//

/// This class defines the interface for handling inlining with sdir
/// operations.
struct SdirInlinerInterface : public DialectInlinerInterface {
  using DialectInlinerInterface::DialectInlinerInterface;

  //===--------------------------------------------------------------------===//
  // Analysis Hooks
  //===--------------------------------------------------------------------===//

  /// All call operations within sdir can be inlined.
  bool isLegalToInline(Operation *call, Operation *callable,
                       bool wouldBeCloned) const final {
    return true;
  }

  /// All operations within sdir can be inlined.
  bool isLegalToInline(Operation *, Region *, bool, IRMapping &) const final {
    return true;
  }

  // All functions within sdir can be inlined.
  bool isLegalToInline(Region *, Region *, bool, IRMapping &) const final {
    return true;
  }

  //===--------------------------------------------------------------------===//
  // Transformation Hooks
  //===--------------------------------------------------------------------===//

  // /// Handle the given inlined terminator(sdir.return) by replacing it with a new
  // /// operation as necessary.
  // void handleTerminator(Operation *op, ValueRange valuesToRepl) const final {
  //   // Only "sdir.return" needs to be handled here.
  //   auto returnOp = cast<ReturnOp>(op);

  //   // Replace the values directly with the return operands.
  //   assert(returnOp.getNumOperands() == valuesToRepl.size());
  //   for (const auto &it : llvm::enumerate(returnOp.getOperands()))
  //     valuesToRepl[it.index()].replaceAllUsesWith(it.value());
  // }

  /// Attempts to materialize a conversion for a type mismatch between a call
  /// from this dialect, and a callable region. This method should generate an
  /// operation that takes 'input' as the only operand, and produces a single
  /// result of 'resultType'. If a conversion can not be generated, nullptr
  /// should be returned.
  // Operation *materializeCallConversion(OpBuilder &builder, Value input,
  //                                      Type resultType,
  //                                      Location conversionLoc) const final {
  //   return builder.create<CastOp>(conversionLoc, resultType, input);
  // }
};

//===----------------------------------------------------------------------===//
// SdirDialect
//===----------------------------------------------------------------------===//

void SdirDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Sdir/IR/SdirOps.cpp.inc"
      >();
  addInterfaces<SdirInlinerInterface>();
  registerTypes();
}
