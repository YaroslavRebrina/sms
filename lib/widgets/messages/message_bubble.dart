import 'package:flutter/material.dart';

Widget messageBubble(bool isSent, String message) {
  return Align(
    alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: TextStyle(
            color: isSent ? Colors.white : Colors.black, fontSize: 18),
      ),
    ),
  );
}
