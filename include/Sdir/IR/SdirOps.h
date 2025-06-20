//===- SdirOps.h - Sdir dialect ops -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SDIR_SDIROPS_H
#define SDIR_SDIROPS_H

#include "Sdir/IR/SdirTypes.h"

#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionImplementation.h"


#define GET_OP_CLASSES
#include "Sdir/IR/SdirOps.h.inc"

#endif // SDIR_SDIROPS_H
