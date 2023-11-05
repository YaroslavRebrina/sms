import 'package:flutter/material.dart';

class ButtonWithPadding extends StatelessWidget {
  const ButtonWithPadding(
      {super.key, required this.icon, required this.padding});
  final Widget icon;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: icon,
    );
  }
}
