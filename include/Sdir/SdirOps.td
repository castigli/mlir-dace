//===- SdirOps.td - Sdir dialect ops -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SDIR_OPS
#define SDIR_OPS

include "Sdir/SdirTypes.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/OpBase.td"

def Sdir_FooOp : Sdir_Op<"foo", [Pure,
                                             SameOperandsAndResultType]> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The `Sdir.foo` operation illustrates how to define a new
        operation in a dialect. It uses an operation trait to declare that it
        has no side effects.

        This operation takes an integer argument and returns an integer.

        Example:

        ```mlir
        %0 = arith.constant 2 : i32
        // Apply the foo operation to %0
        %1 = Sdir.foo %0 : i32
        ```
    }];

    let arguments = (ins I32:$input);
    let results = (outs I32:$res);

    let assemblyFormat = [{
        $input attr-dict `:` type($input)
    }];
}


//===----------------------------------------------------------------------===//
// SdfgOp
//===----------------------------------------------------------------------===//


def Sdir_SdfgOp : Sdir_Op<"sdfg", [
    ParentOneOf<["ModuleOp"]>,
    NoTerminator,
    IsolatedFromAbove
    // DeclareOpInterfaceMethods<SymbolUserOpInterface>
]> {
    let summary = "SDFG region";
    let description = [{
        SDFGs may only contain states and scf state (loops, conditionals) and symbolic ops.
        Executes its body in-order. 
       
        For example:

        ```mlir
        sdir.sdfg (%arg0: !sdfg.array<2xi32>, %arg1: !sdfg.array<1xi32>) {
            sdir.state {
                %c0 = arith.constant 0 : index
                %a = sdir.load %arg0 [%c0] : !sdfg.array<2xi32>
                %c = arith.add %a %a : i32
                %d = arith.add %c %c : i32
                sdir.store %d, %arg1 [%c0] : !sdfg.array<1xi32>
            }
            sdir.for_state () {
                sdir.state {...}
                sdir.state {...}
                sdir.if_state() {
                ...
                }
            }  
            sdir.state ( ) {

            }
        }
        ```

        // TODO: limit allowed types as arguments.
    }];

    let arguments = (ins
        Variadic<AnyArray>:$arguments
    );

    let regions = (region SizedRegion<1>:$body);

}

#endif // SDIR_OPS
