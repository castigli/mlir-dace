// RUN: sdir-opt -allow-unregistered-dialect %s | sdir-opt -allow-unregistered-dialect | FileCheck %s

module {
    // CHECK-LABEL: func private @sdir_array() -> !sdir.array<1x1xf32>
    func.func private @sdir_array() -> !sdir.array<1x1xf32>
    // CHECK-LABEL: func private @sdir_layout() -> !sdir.array<?x?xf32, strided<[42, 1]>>
    func.func private @sdir_layout() -> !sdir.array<?x?xf32, strided<[42, 1], offset: 0>>
    // CHECK-LABEL: func private @sdir_layout_offset() -> !sdir.array<?x?xf32, strided<[42, 1], offset: 10>>
    func.func private @sdir_layout_offset() -> !sdir.array<?x?xf32, strided<[42, 1], offset: 10>>
    // CHECK-LABEL: func private @sdir_memspace_cpu() -> !sdir.array<10x20xf32, 0>
    func.func private @sdir_memspace_cpu() -> !sdir.array<10x20xf32, 0>
    // CHECK-LABEL: func private @sdir_memspace_gpu() -> !sdir.array<10x20xf32, #gpu.address_space<global>>
    func.func private @sdir_memspace_gpu() -> !sdir.array<10x20xf32, #gpu.address_space<global>>
    // CHECK-LABEL: func private @sdir_layout_offset_mem() -> !sdir.array<?x?xf32, strided<[42, 1], offset: 10>, 1>
    func.func private @sdir_layout_offset_mem() -> !sdir.array<?x?xf32, strided<[42, 1], offset: 10>, 1>
}

