//===- SdirPasses.h - Sdir passes  ------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#ifndef SDIR_SDIRPASSES_H
#define SDIR_SDIRPASSES_H

#include "Sdir/SdirDialect.h"
#include "Sdir/SdirOps.h"
#include "mlir/Pass/Pass.h"
#include <memory>

namespace mlir {
namespace sdir {
#define GEN_PASS_DECL
#include "Sdir/SdirPasses.h.inc"

#define GEN_PASS_REGISTRATION
#include "Sdir/SdirPasses.h.inc"
} // namespace sdir
} // namespace mlir

#endif
