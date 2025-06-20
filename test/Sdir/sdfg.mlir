// RUN: sdir-opt %s | sdir-opt | FileCheck %s

module {
// CHECK: sdir.sdfg @sdfg0(%arg0: !sdir.array<2xi32>, %arg1: !sdir.array<1xi32>) {
    sdir.sdfg @sdfg0(%arg0: !sdir.array<2xi32>, %arg1: !sdir.array<1xi32>) {
        %c0 = arith.constant 0 : index
    }
}

