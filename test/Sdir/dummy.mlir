// RUN: sdir-opt %s | sdir-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        // CHECK: %{{.*}} = sdir.foo %{{.*}} : i32
        %res = sdir.foo %0 : i32
        return
    }

    // CHECK-LABEL: func @sdir_types(%arg0: !sdir.custom<"10">)
    func.func @sdir_types(%arg0: !sdir.custom<"10">) {
        return
    }
}
