// RUN: mlir-opt %s --load-dialect-plugin=%sdir_libs/SdirPlugin%shlibext --pass-pipeline="builtin.module(sdir-switch-bar-foo)" | FileCheck %s

module {
  // CHECK-LABEL: func @foo()
  func.func @bar() {
    return
  }

  // CHECK-LABEL: func @sdir_types(%arg0: !sdir.custom<"10">)
  func.func @sdir_types(%arg0: !sdir.custom<"10">) {
    return
  }
}
