import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, super.locale}) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(0);
    setMiddleIndex(0);
    setRightIndex(0);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      //数値を表示するウィジェット。引数：表示する数値,桁数
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 0, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          currentLeftIndex(),
          currentRightIndex(),
          0,
        )
        : DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          currentLeftIndex(),
          currentRightIndex(),
          0,
        );
  }
}
