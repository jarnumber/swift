// RUN: %swift -parse-as-library -emit-silgen %s | FileCheck %s

// CHECK: sil private @globalinit_[[T:.*]]_func0 : $@thin () -> () {
// CHECK:   [[XADDR:%.*]] = sil_global_addr @_Tv12lazy_globals1xSi : $*Int
// CHECK:   store {{%.*}} to [[XADDR]] : $*Int
// CHECK: sil hidden [global_init] @_TF12lazy_globalsa1xSi : $@thin () -> Builtin.RawPointer {
// CHECK:   [[TOKEN_ADDR:%.*]] = sil_global_addr @globalinit_[[T]]_token0 : $*Builtin.Word
// CHECK:   [[TOKEN_PTR:%.*]] = address_to_pointer [[TOKEN_ADDR]] : $*Builtin.Word to $Builtin.RawPointer
// CHECK:   [[INIT_FUNC:%.*]] = function_ref @globalinit_[[T]]_func0 : $@thin () -> ()
// CHECK:   [[INIT_FUNC_THICK:%.*]] = thin_to_thick_function [[INIT_FUNC]] : $@thin () -> () to $@callee_owned () -> ()
// CHECK:   builtin "once"([[TOKEN_PTR]] : $Builtin.RawPointer, [[INIT_FUNC_THICK]] : $@callee_owned () -> ()) : $()
// CHECK:   [[GLOBAL_ADDR:%.*]] = sil_global_addr @_Tv12lazy_globals1xSi : $*Int
// CHECK:   [[GLOBAL_PTR:%.*]] = address_to_pointer [[GLOBAL_ADDR]] : $*Int to $Builtin.RawPointer
// CHECK:   return [[GLOBAL_PTR]] : $Builtin.RawPointer
// CHECK: }
var x: Int = 0

struct Foo {
// CHECK: sil hidden [global_init] @_TFV12lazy_globals3Fooa3fooSi : $@thin () -> Builtin.RawPointer {
  static var foo: Int = 22

  static var computed: Int {
    return 33
  }

  static var initialized: Int = 57
}

enum Bar {
// CHECK: sil hidden [global_init] @_TFO12lazy_globals3Bara3barSi : $@thin () -> Builtin.RawPointer {
  static var bar: Int = 33
}

// We only emit one initializer function per pattern binding, which initializes
// all of the bound variables.

func f() -> (Int, Int) { return (1, 2) }

// CHECK: sil private @globalinit_[[T]]_func4 : $@thin () -> () {
// CHECK:   function_ref @_TF12lazy_globals1fFT_TSiSi_ : $@thin () -> (Int, Int)
// CHECK: sil hidden [global_init] @_TF12lazy_globalsa2a1Si : $@thin () -> Builtin.RawPointer
// CHECK:   function_ref @globalinit_[[T]]_func4 : $@thin () -> ()
// CHECK:   sil_global_addr @_Tv12lazy_globals2a1Si : $*Int
// CHECK: sil hidden [global_init] @_TF12lazy_globalsa2b1Si : $@thin () -> Builtin.RawPointer {
// CHECK:   function_ref @globalinit_[[T]]_func4 : $@thin () -> ()
// CHECK:   sil_global_addr @_Tv12lazy_globals2b1Si : $*Int
var (a1, b1) = f()

var computed: Int {
  return 44
}

var initialized: Int = 57

