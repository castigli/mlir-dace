//===- SdirExtensionPybind11.cpp - Extension module -----------------===//
//
// This is the pybind11 version of the example module. There is also a nanobind
// example in SdirExtensionNanobind.cpp.
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Sdir-c/Dialects.h"
#include "mlir/Bindings/Python/PybindAdaptors.h"

using namespace mlir::python::adaptors;

PYBIND11_MODULE(_SdirDialectsPybind11, m) {
  //===--------------------------------------------------------------------===//
  // Sdir dialect
  //===--------------------------------------------------------------------===//
  auto SdirM = m.def_submodule("Sdir");

  SdirM.def(
      "register_dialect",
      [](MlirContext context, bool load) {
        MlirDialectHandle handle = mlirGetDialectHandle__sdir__();
        mlirDialectHandleRegisterDialect(handle, context);
        if (load) {
          mlirDialectHandleLoadDialect(handle, context);
        }
      },
      py::arg("context") = py::none(), py::arg("load") = true);
}
