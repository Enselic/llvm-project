// Test to verify that line stepping works correctly with dbg_declare.
// This test verifies that GDB can step through lines correctly and that
// dbg_declare provides variable location information.
//
// RUN: %clang %target_itanium_abi_host_triple -O0 -g %s -o %t.out
// RUN: %test_debuginfo %s %t.out
// REQUIRES: system-linux
// XFAIL: gdb-clang-incompatibility
//
// This test confirms that:
// 1. Line stepping through the program works as expected
// 2. Variable values can be inspected (thanks to dbg_declare)

int add(int a, int b) {
    // DEBUGGER: break 15
    int result = a + b;
    return result;
}

int main() {
    int x = 10;
    int y = 20;
    // DEBUGGER: break 24
    int z = add(x, y);
    return z;
}

// Test that we can step to the add function and see variable values
// DEBUGGER: r
// DEBUGGER: p x
// CHECK: = 10
// DEBUGGER: p y  
// CHECK: = 20
// DEBUGGER: c
// DEBUGGER: p a
// CHECK: = 10
// DEBUGGER: p b
// CHECK: = 20
// DEBUGGER: n
// DEBUGGER: p result
// CHECK: = 30
