// Test to verify that #dbg_declare does not affect GDB line stepping behavior.
// This test demonstrates that dbg_declare only provides variable location
// information to debuggers but does not change the line number table or
// stepping behavior.
//
// RUN: %clang -g -O0 -S -emit-llvm %s -o %t.ll
// RUN: %clang -g -O0 %s -o %t.with
// RUN: sed '/llvm.dbg.declare/d' %t.ll > %t_no_dbg.ll
// RUN: %clang %t_no_dbg.ll -o %t.without
// RUN: llvm-dwarfdump --debug-line %t.with > %t.with.line
// RUN: llvm-dwarfdump --debug-line %t.without > %t.without.line
// RUN: diff %t.with.line %t.without.line
//
// This test verifies that the DWARF line number tables are identical
// with and without dbg_declare records, confirming that dbg_declare
// does not affect line stepping in GDB.

int add(int a, int b) {
    int result = a + b;
    return result;
}

int main() {
    int x = 10;
    int y = 20;
    int z = add(x, y);
    return z;
}
