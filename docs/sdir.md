# SDIR Dialect

## SDFGs
```mlir
sdir.sdfg (%arg0: !sdfg.array<1xi32>, %arg1: !sdfg.array<1xi32>) {
...
}
```
The start of an SDFG program.
The provided arguments may be used as outputs (pass-by-reference).
SDFGs may only contain states, loops, conditionals, and symbolics.
Executes its body in-order.


## States
```mlir
sdir.state {
  
}
```

This represents a grouping of operations, where each independent subgraph of operations is executed in parallel.
In particular, no ordering of the subgraphs may be assumed.
The user is responsible for ensuring that there are no data races, which break the correctness of the program.
States may only contain array accesses, maps, and nested SDFGs.

## Conditionals
```mlir
sdir.if %b  {
  ...
}
```

They may only contain states, loops,  conditionals, and symbolics.
Constrains are checked by the verifier.
Can be lowered directly to the SCF dialect and the regular `scf.if` constrains apply.
See: https://mlir.llvm.org/docs/Dialects/SCFDialect/#scfif-scfifop

## Loops
```mlir
sdir.for %iv = %lb to %ub step %step {
  ...
}
```

They may only contain states, loops, conditionals, and symbolics.
Constrains are checked by the verifier.
State loops can be lowered directly to the SCF dialect and the regular `scf.for` constrains apply.
See: https://mlir.llvm.org/docs/Dialects/SCFDialect/#scffor-scfforop

If implemented with interfaces we might be able to reuse all the core passes.


## Maps (parallel for)
```mlir
sdir.parallel (%iv) = (%lb) to (%ub) step (%step) {
  ...
}
```

Maps are represented using the parallel op.
They may only contain array accesses, maps, and nested SDFGs.
Can be lowered directly to the SCF dialect and the regular `scf.parallel` constraints apply.
See: https://mlir.llvm.org/docs/Dialects/SCFDialect/#scfparallel-scfparallelop

## Reduce
```mlir
scf.reduce
```
Reduce ops for sdir.parallel, reuse `scf.reduce`
See: https://mlir.llvm.org/docs/Dialects/SCFDialect/#scfreduce-scfreduceop


## Symbols
```mlir
%0 = sdfg.sym "s0" {min_val = 5, max_val = 10} : !sdfg.int
%1 = sdfg.sym "s1" : !sdfg.int
```
Symbols or symbolic sizes are not natively supported in MLIR, we borrow from torch-mlir `symbolic_int` implementation.
The `sym` op associates the symbol "s0" with a SSA value (for instance, `%0`). 
When unspecified the range defaults to [0, INT_MAX].
See: https://github.com/llvm/torch-mlir/blob/main/include/torch-mlir/Dialect/Torch/IR/TorchOps.td

## Symbolic shapes (expressions)
```mlir
sdir.bind_sym_shape %arg0, [%0, %1], affine_map<()[s0, s1] -> (s0, s1, 3)> : !sdir.array<?x?x3,f32>
```    
Symbolics shape or expression ops binds expressions useful to compute dynamic dimensions of a shaped type. This op closely follows torch.mlir `bind_symbolic_shape`: it takes a variadic of SSA symbols that map 1:1 to the local symbols declared in the affine map. The affine map contains a list of affine shape expressions for each dim where the terminals are from the declared
symbols.
See: https://github.com/llvm/torch-mlir/pull/3372
     https://github.com/cruise-automation/mlir-tcp/pull/78/files

## Arrays
```mlir
!sdir.array<15x?xi32, #layout, #memory_space> 
```
Arrays reprensent bufferized containers similarly to `memrefs`. `#layout` and `#memory_space` are optional attributes that defaults to right major and cpu main memory.
https://mlir.llvm.org/docs/Dialects/Builtin/#memreftype

## Slices (views) 

Perhaps we want to allow accessing a range and introduce a "slice" type?

(G) can this be done with some similar to memref.view or subview ops, does that cover the use case?

## Load 
```mlir
%a = sdir.load %A[0, 0] : !sdir.array<15x?xi32> -> i32
```

## Store
```mlir
sdir.store %a, %C[0, 0] : i32 -> !sdir.array<15x?xi32>
```

## Alloc
```mlir
%arr = sdir.alloc()[%dim] : !sdir.array<15x?xi32>
```
Heap allocation op, follows `memref.alloc` semantic.
See: https://mlir.llvm.org/docs/Dialects/MemRef/#memrefalloc-memrefallocop

## Dealloc
```mlir
sdir.dealloc %arr : !sdir.array<15x?xi32>
```
Deallocation op

## Alloca
```mlir
%sarr = sdir.alloca() : !sdir.array<15xi32>
```
Stack allocation op

## Tasklets
Tasklets are not explictly represented in SDIR, any non-SDIR op (e.g. `arith.add`) would be emitted as a tasklet.


# Open Questions
- (G) do we need sdir.array? any sematinc difference with memrefs?
- (G) define subgraph in sdir.state, is that any SDIR ops?