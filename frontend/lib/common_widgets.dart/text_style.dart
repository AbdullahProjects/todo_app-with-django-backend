import 'package:frontend/constants/consts.dart';

Widget normalText({text = "Normal Title", color = Colors.white, size = 14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText({text = "Bold Title", color = Colors.white, size = 14.0}) {
  return "$text"
      .text
      .color(color)
      .size(size)
      .fontWeight(FontWeight.bold)
      .make();
}
