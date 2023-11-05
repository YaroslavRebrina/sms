import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class ChatItemUserIcon extends StatelessWidget {
  const ChatItemUserIcon({
    super.key,
    required this.randomColor,
  });

  final RandomColor randomColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
              color: randomColor.randomColor(
                  colorHue: ColorHue.multiple(colorHues: [
                    ColorHue.blue,
                    ColorHue.green,
                    ColorHue.orange,
                    ColorHue.red,
                    ColorHue.purple
                  ]),
                  colorBrightness: ColorBrightness.light,
                  colorSaturation: ColorSaturation.mediumSaturation),
              shape: const CircleBorder()),
          child: Icon(
            Icons.person,
            color: Colors.grey.shade300,
          )),
    );
  }
}
