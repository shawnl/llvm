; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='simplify-cfg<switch-to-lookup>' < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

attributes #0 = { "no-jump-tables"="false" }

define i64 @switch_common_right_bits(i8 %a) #0  {
; CHECK-LABEL: @switch_common_right_bits(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i8 [[A:%.*]], 123
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.fshr.i8(i8 [[TMP0]], i8 [[TMP0]], i8 1)
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i8 [[TMP1]], 5
; CHECK-NEXT:    br i1 [[TMP2]], label [[SWITCH_LOOKUP:%.*]], label [[SWITCHELSE:%.*]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [5 x i64], [5 x i64]* @switch.table.switch_common_right_bits, i32 0, i8 [[TMP1]]
; CHECK-NEXT:    [[SWITCH_LOAD:%.*]] = load i64, i64* [[SWITCH_GEP]]
; CHECK-NEXT:    ret i64 [[SWITCH_LOAD]]
; CHECK:       SwitchElse:
; CHECK-NEXT:    ret i64 10
;
Entry:
  switch i8 %a, label %SwitchElse [
  i8 123, label %SwitchProng
  i8 125, label %SwitchProng1
  i8 127, label %SwitchProng2
  i8 129, label %SwitchProng3
  i8 131, label %SwitchProng4
  ]
SwitchElse:                                       ; preds = %Entry
  ret i64 10
SwitchProng:                                      ; preds = %Entry
  ret i64 6
SwitchProng1:                                     ; preds = %Entry
  ret i64 3
SwitchProng2:                                     ; preds = %Entry
  ret i64 4
SwitchProng3:                                     ; preds = %Entry
  ret i64 2
SwitchProng4:                                     ; preds = %Entry
  ret i64 1
}

define i64 @switch_clz1(i16 %a) optsize #0  {
; CHECK-LABEL: @switch_clz1(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    switch i16 [[A:%.*]], label [[SWITCHELSE:%.*]] [
; CHECK-NEXT:    i16 2, label [[SWITCHPRONG:%.*]]
; CHECK-NEXT:    i16 4, label [[SWITCHPRONG1:%.*]]
; CHECK-NEXT:    i16 8, label [[SWITCHPRONG2:%.*]]
; CHECK-NEXT:    i16 1, label [[SWITCHPRONG3:%.*]]
; CHECK-NEXT:    i16 64, label [[SWITCHPRONG6:%.*]]
; CHECK-NEXT:    i16 128, label [[SWITCHPRONG7:%.*]]
; CHECK-NEXT:    i16 16, label [[SWITCHPRONG5:%.*]]
; CHECK-NEXT:    i16 32, label [[SWITCHPRONG4:%.*]]
; CHECK-NEXT:    ]
; CHECK:       SwitchElse:
; CHECK-NEXT:    [[MERGE:%.*]] = phi i64 [ 10, [[ENTRY:%.*]] ], [ 6, [[SWITCHPRONG]] ], [ 3, [[SWITCHPRONG1]] ], [ 35, [[SWITCHPRONG2]] ], [ 31, [[SWITCHPRONG3]] ], [ 53, [[SWITCHPRONG4]] ], [ 51, [[SWITCHPRONG5]] ], [ 41, [[SWITCHPRONG6]] ], [ 34, [[SWITCHPRONG7]] ]
; CHECK-NEXT:    ret i64 [[MERGE]]
; CHECK:       SwitchProng:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng1:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng2:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng3:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng4:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng5:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng6:
; CHECK-NEXT:    br label [[SWITCHELSE]]
; CHECK:       SwitchProng7:
; CHECK-NEXT:    br label [[SWITCHELSE]]
;
Entry:
  switch i16 %a, label %SwitchElse [
  i16 2, label %SwitchProng
  i16 4, label %SwitchProng1
  i16 8, label %SwitchProng2
  i16 1, label %SwitchProng3
  i16 64, label %SwitchProng6
  i16 128, label %SwitchProng7
  i16 16, label %SwitchProng5
  i16 32, label %SwitchProng4
  ]
SwitchElse:                                       ; preds = %Entry
  ret i64 10
SwitchProng:                                      ; preds = %Entry
  ret i64 6
SwitchProng1:                                     ; preds = %Entry
  ret i64 3
SwitchProng2:                                     ; preds = %Entry
  ret i64 35
SwitchProng3:                                     ; preds = %Entry
  ret i64 31
SwitchProng4:                                     ; preds = %Entry
  ret i64 53
SwitchProng5:                                     ; preds = %Entry
  ret i64 51
SwitchProng6:                                     ; preds = %Entry
  ret i64 41
SwitchProng7:                                     ; preds = %Entry
  ret i64 34
}

define i64 @switch_clz2(i8 %a) optsize #0  {
; CHECK-LABEL: @switch_clz2(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    switch i8 [[A:%.*]], label [[SWITCHELSE:%.*]] [
; CHECK-NEXT:    i8 -128, label [[SWITCHPRONG2:%.*]]
; CHECK-NEXT:    i8 64, label [[SWITCHPRONG3:%.*]]
; CHECK-NEXT:    i8 32, label [[SWITCHPRONG6:%.*]]
; CHECK-NEXT:    i8 1, label [[SWITCHPRONG7:%.*]]
; CHECK-NEXT:    i8 0, label [[SWITCHPRONG5:%.*]]
; CHECK-NEXT:    ]
; CHECK:       SwitchProng2:
; CHECK-NEXT:    [[MERGE:%.*]] = phi i64 [ 35, [[ENTRY:%.*]] ], [ 31, [[SWITCHPRONG3]] ], [ 41, [[SWITCHPRONG6]] ], [ 40, [[SWITCHPRONG5]] ], [ 43, [[SWITCHPRONG7]] ], [ 12, [[SWITCHELSE]] ]
; CHECK-NEXT:    ret i64 [[MERGE]]
; CHECK:       SwitchProng3:
; CHECK-NEXT:    br label [[SWITCHPRONG2]]
; CHECK:       SwitchProng6:
; CHECK-NEXT:    br label [[SWITCHPRONG2]]
; CHECK:       SwitchProng5:
; CHECK-NEXT:    br label [[SWITCHPRONG2]]
; CHECK:       SwitchProng7:
; CHECK-NEXT:    br label [[SWITCHPRONG2]]
; CHECK:       SwitchElse:
; CHECK-NEXT:    br label [[SWITCHPRONG2]]
;
Entry:
  switch i8 %a, label %SwitchElse [
  i8 128, label %SwitchProng2
  i8 64, label %SwitchProng3
  i8 32, label %SwitchProng6
  i8 1, label %SwitchProng7
  i8 0, label %SwitchProng5
  ]
SwitchProng2:                                     ; preds = %Entry
  ret i64 35
SwitchProng3:                                     ; preds = %Entry
  ret i64 31
SwitchProng6:                                     ; preds = %Entry
  ret i64 41
SwitchProng5:                                     ; preds = %Entry
  ret i64 40
SwitchProng7:                                     ; preds = %Entry
  ret i64 43
SwitchElse:                                     ; preds = %Entry
  ret i64 12
}

;Must check that the default was filled in at index 0 as happened here:
;@switch.table.switch_not_normalized_to_start_at_zero = private unnamed_addr constant [6 x i16] [i16 10, i16 7, i16 3, i16 1, i16 6, i16 8], align 2
define i16 @switch_not_normalized_to_start_at_zero(i8 %a) #0  {
; CHECK-LABEL: @switch_not_normalized_to_start_at_zero(
; CHECK-NEXT:  Entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i8 [[A:%.*]], 6
; CHECK-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[SWITCHELSE:%.*]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [6 x i16], [6 x i16]* @switch.table.switch_not_normalized_to_start_at_zero, i32 0, i8 [[A]]
; CHECK-NEXT:    [[SWITCH_LOAD:%.*]] = load i16, i16* [[SWITCH_GEP]]
; CHECK-NEXT:    ret i16 [[SWITCH_LOAD]]
; CHECK:       SwitchElse:
; CHECK-NEXT:    ret i16 10
;
Entry:
  switch i8 %a, label %SwitchElse [
  i8 4, label %SwitchProng
  i8 2, label %SwitchProng1
  i8 1, label %SwitchProng2
  i8 3, label %SwitchProng3
  i8 5, label %SwitchProng4
  ]
SwitchElse:                                       ; preds = %Entry
  ret i16 10
SwitchProng:                                      ; preds = %Entry
  ret i16 6
SwitchProng1:                                     ; preds = %Entry
  ret i16 3
SwitchProng2:                                     ; preds = %Entry
  ret i16 7
SwitchProng3:                                     ; preds = %Entry
  ret i16 1
SwitchProng4:                                     ; preds = %Entry
  ret i16 8
}
