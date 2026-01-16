import 'package:yotei/sys_variable.dart';
import 'package:yotei/class_screen.dart';
import 'package:yotei/sonota_screen.dart';

getSlide() {
  if (slide == 0) {
    return ClassScreem();
  } else {
    return SonotaScreem();
  }
}
