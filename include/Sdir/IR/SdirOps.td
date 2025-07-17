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
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/OpBase.td"


//===----------------------------------------------------------------------===//
// SdfgOp
//===----------------------------------------------------------------------===//


def Sdir_SdfgOp : Sdir_Op<"sdfg", [
  // SingleBlockImplicitTerminator<"SdfgReturnOp">,
  FunctionOpInterface, 
  IsolatedFromAbove
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
        // TODO: add invariants to verifier
        // -  limit allowed types as arguments (only sdir.array?)
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

//===----------------------------------------------------------------------===//
// SdfgCallOp
//===----------------------------------------------------------------------===//

def SdfgCallOp : Sdir_Op<"sdfg.call",
    [DeclareOpInterfaceMethods<CallOpInterface>]> {
  let summary = "sdfg call operation";
  let description = [{
   
    ```mlir
    sdir.call.sdfg @mysdfg(%1, %3)
           : (!sdir.array<2xi32>, !sdir.array<1xi32>)
    ```

  
  }];

  // The call operation takes a symbol reference attribute as the
  // callee, and inputs for the call.
  let arguments = (ins FlatSymbolRefAttr:$callee, Variadic<AnyArray>:$inputs);


  let assemblyFormat = [{
    $callee `(` $inputs `)` attr-dict `:` type($inputs)
  }];

  let builders = [
    OpBuilder<(ins "StringRef":$callee, "ArrayRef<Value>":$arguments)>
  ];
}

def Sdir_SdfgReturnOp : Sdir_Op<"sdfg.return",
    [Pure, Terminator,
     HasParent<"SdfgOp">]> {
  let summary = "special terminator for use in sdfg operations";

  let description = [{
    Terminator for sdir.sdfg operations. This operation is used to implicitlly 
    terminate the body of an SDFG region and need not appear in the textual
    representation.
    It is a workaround for the FunctionOpInterface machinery which requires 
    a terminator and dor not support the NoTerminator trait.    
  }];

  let assemblyFormat = [{
    attr-dict
  }];

}

#endif // SDIR_OPS
