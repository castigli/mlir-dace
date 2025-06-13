// RUN: mlir-opt %s --load-pass-plugin=%sdir_libs/SdirPlugin%shlibext --pass-pipeline="builtin.module(sdir-switch-bar-foo)" | FileCheck %s

module {
  // CHECK-LABEL: func @foo()
  func.func @bar() {
    return
  }

  // CHECK-LABEL: func @abar()
  func.func @abar() {
    return
  }
}
