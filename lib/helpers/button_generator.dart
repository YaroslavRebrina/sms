import 'package:flutter/material.dart';
import 'package:sms/widgets/buttons_list.dart';

List<Widget> genButton(
    {required List<Widget> buttons, required double padding}) {
  final List<Widget> result = buttons
      .map((button) => ButtonWithPadding(icon: button, padding: padding))
      .toList();

  return result;
}
