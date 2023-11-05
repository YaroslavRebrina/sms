import 'package:flutter/material.dart';
import 'package:sms/helpers/time_getter.dart';
import './message_bubble.dart';

Widget messageWithTime(int isSent, String message) {
  String currentTime =
      getCurrentHoursMinutes(); // Assuming you have this function

  return Column(
    crossAxisAlignment:
        isSent == 1 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      messageBubble(isSent == 1 ? true : false, message),
      Padding(
        padding: EdgeInsets.only(
            right: isSent == 1 ? 15 : 0, left: isSent == 0 ? 15 : 0, top: 2),
        child: Text(
          currentTime,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      )
    ],
  );
}
