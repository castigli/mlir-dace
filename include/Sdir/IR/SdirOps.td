//===- SdirOps.td - Sdir dialect ops -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SDIR_OPS
#define SDIR_OPS

include "Sdir/IR/SdirTypes.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/OpBase.td"


//===----------------------------------------------------------------------===//
// SdfgOp
//===----------------------------------------------------------------------===//


def Sdir_SdfgOp : Sdir_Op<"sdfg", [
  FunctionOpInterface, 
  IsolatedFromAbove,
  NoTerminator,
  SingleBlock
]> {
    let summary = "SDFG region";
    let description = [{
        SDFGs may only contain states and scf state (loops, conditionals) and symbolic ops.
        Executes its body in-order. 
       
        For example:

        ```mlir
        sdir.sdfg @sdfg0(%arg0: !sdfg.array<2xi32>, %arg1: !sdfg.array<1xi32>) {
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
        // TODO: check no return value in verifier
    }];

  let arguments = (ins
    SymbolNameAttr:$sym_name,
    TypeAttrOf<FunctionType>:$function_type,
    OptionalAttr<DictArrayAttr>:$arg_attrs,
    OptionalAttr<DictArrayAttr>:$res_attrs
  );
  let regions = (region SizedRegion<1>:$body);

  let builders = [OpBuilder<(ins
    "StringRef":$name, "FunctionType":$type,
    CArg<"ArrayRef<NamedAttribute>", "{}">:$attrs)
  >];
  let extraClassDeclaration = [{
    //===------------------------------------------------------------------===//
    // FunctionOpInterface Methods
    //===------------------------------------------------------------------===//

    /// Returns the argument types of this function.
    ArrayRef<Type> getArgumentTypes() { return getFunctionType().getInputs(); }

    /// Returns the result types of this function.
    ArrayRef<Type> getResultTypes() { return getFunctionType().getResults(); }

    Region *getCallableRegion() { return &getBody(); }
  }];
  let hasCustomAssemblyFormat = 1;
  let skipDefaultBuilders = 1;

}

#endif // SDIR_OPS
