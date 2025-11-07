; RUN: llc -o - %s -filetype=obj | llvm-dwarfdump -debug-line - | FileCheck %s
; RUN: sed 's/call void @llvm.dbg.declare.*/; REMOVED/' %s | llc -o - -filetype=obj | llvm-dwarfdump -debug-line - | FileCheck %s
;
; This test verifies that llvm.dbg.declare intrinsics do not affect the DWARF
; line number table generation. The line table should be identical whether
; dbg.declare calls are present or removed.
;
; The test compiles the IR twice:
; 1. With dbg.declare calls present
; 2. With dbg.declare calls removed (via sed)
; Both should produce identical line number tables.

; CHECK: debug_line
; CHECK: Line table prologue:
; CHECK: file_names[  0]:
; CHECK-NEXT: name: "test.c"
; CHECK: Address            Line   Column File   ISA Discriminator OpIndex Flags
; CHECK: 0x{{[0-9a-f]+}}        4      0      0   0             0         0  is_stmt
; CHECK: 0x{{[0-9a-f]+}}        5     18      0   0             0         0  is_stmt prologue_end
; CHECK: 0x{{[0-9a-f]+}}        6     12      0   0             0         0  is_stmt

source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @add(i32 noundef %a, i32 noundef %b) !dbg !10 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 %a, ptr %a.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %a.addr, metadata !15, metadata !DIExpression()), !dbg !16
  store i32 %b, ptr %b.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %b.addr, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata ptr %result, metadata !19, metadata !DIExpression()), !dbg !20
  %0 = load i32, ptr %a.addr, align 4, !dbg !21
  %1 = load i32, ptr %b.addr, align 4, !dbg !22
  %add = add nsw i32 %0, %1, !dbg !23
  store i32 %add, ptr %result, align 4, !dbg !20
  %2 = load i32, ptr %result, align 4, !dbg !24
  ret i32 %2, !dbg !25
}

declare void @llvm.dbg.declare(metadata, metadata, metadata)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "test.c", directory: "/tmp")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 2}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"clang"}
!10 = distinct !DISubprogram(name: "add", scope: !1, file: !1, line: 4, type: !11, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!11 = !DISubroutineType(types: !12)
!12 = !{!13, !13, !13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "a", arg: 1, scope: !10, file: !1, line: 4, type: !13)
!16 = !DILocation(line: 4, column: 13, scope: !10)
!17 = !DILocalVariable(name: "b", arg: 2, scope: !10, file: !1, line: 4, type: !13)
!18 = !DILocation(line: 4, column: 20, scope: !10)
!19 = !DILocalVariable(name: "result", scope: !10, file: !1, line: 5, type: !13)
!20 = !DILocation(line: 5, column: 9, scope: !10)
!21 = !DILocation(line: 5, column: 18, scope: !10)
!22 = !DILocation(line: 5, column: 22, scope: !10)
!23 = !DILocation(line: 5, column: 20, scope: !10)
!24 = !DILocation(line: 6, column: 12, scope: !10)
!25 = !DILocation(line: 6, column: 5, scope: !10)
