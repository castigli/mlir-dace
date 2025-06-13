# RUN: %python %s pybind11 | FileCheck %s
# RUN: %python %s nanobind | FileCheck %s

import sys
from mlir_sdir.ir import *
from mlir_sdir.dialects import builtin as builtin_d

if sys.argv[1] == "pybind11":
    from mlir_sdir.dialects import sdir_pybind11 as sdir_d
elif sys.argv[1] == "nanobind":
    from mlir_sdir.dialects import sdir_nanobind as sdir_d
else:
    raise ValueError("Expected either pybind11 or nanobind as arguments")


with Context():
    sdir_d.register_dialect()
    module = Module.parse(
        """
    %0 = arith.constant 2 : i32
    %1 = sdir.foo %0 : i32
    """
    )
    # CHECK: %[[C:.*]] = arith.constant 2 : i32
    # CHECK: Sdir.foo %[[C]] : i32
    print(str(module))
