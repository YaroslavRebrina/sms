import 'package:flutter/material.dart';
import 'package:sms/constants/message.dart';
import 'package:sms/helpers/time_getter.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.title,
    required this.bottomButtons,
    required this.onPressed,
  });
  final String title;
  final List<Icon> bottomButtons;
  final Future<void> Function(
      {required String chatName, required Message message}) onPressed;

  @override
  Widget build(BuildContext context) {
    // Declare TextEditingController here
    final TextEditingController textController = TextEditingController();

    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bottomButtons[0],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bottomButtons[1],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: bottomButtons[2],
            ),
            Expanded(
              flex: 6,
              child: TextField(
                controller: textController, // Assign controller to TextField
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Add this property
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Transform.translate(
              offset: const Offset(8, 0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  Message messageToSend = Message(
                      textController.text, true, getCurrentHoursMinutes());
                  onPressed(chatName: title, message: messageToSend);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
