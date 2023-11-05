import 'package:flutter/material.dart';
import 'package:sms/constants/message.dart';
import 'package:sms/constants/responses.dart';
import 'package:sms/helpers/button_generator.dart';
import 'package:sms/helpers/db_instanse.dart';
import 'package:sms/widgets/bottom_bar.dart';
import 'package:sms/widgets/messages/message_with_time.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.title,
  });

  final String title;
  final List<Widget> buttons = [
    const Icon(
      Icons.phone_enabled_rounded,
    ),
    const Icon(
      Icons.search,
    ),
    const Icon(Icons.more_vert)
  ];
  final List<Icon> bottomButtons = [
    const Icon(Icons.image),
    const Icon(Icons.photo_camera),
    const Icon(Icons.dataset)
  ];
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final ScrollController _scrollController = ScrollController();

class _ChatScreenState extends State<ChatScreen> {
  List<Widget> chatMessages = [];

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void scrollToBottomWithDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollToBottom();
    });
  }

  Future<void> sendMessage(
      {required String chatName, required Message message}) async {
    final db = DatabaseHelper.instance;
    await db.sendMessage(chatName, message);
    setState(
      () {
        addMessage(isSent: 1, text: message.text);
        addMessage(isSent: 0, text: generateResponse(message.text));
      },
    );
    scrollToBottom();
  }

  void addMessage({required int isSent, required String text}) async {
    setState(() {
      chatMessages.add(messageWithTime(isSent, text));
    });
  }

  Future<void> initMessages() async {
    final db = DatabaseHelper.instance;
    final messagesFromDb = await db.getMassagesFromOneChat(widget.title);
    final widgetList = messagesFromDb
        .map((e) =>
            messageWithTime(e['isSent'] as int, e['chatMessages'] as String))
        .toList();

    setState(() {
      chatMessages = widgetList;
    });
    scrollToBottomWithDelay(); // Scroll to the bottom when initialized
  }

  @override
  void initState() {
    super.initState();

    initMessages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          leadingWidth: 30,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            widget.title.substring(4),
            style: const TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          actions: genButton(buttons: widget.buttons, padding: 16.0),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 8),
                controller: _scrollController,
                children: chatMessages,
              ),
            ),
            BottomBar(
              bottomButtons: widget.bottomButtons,
              onPressed: sendMessage,
              title: widget.title,
            )
          ],
        ),
      ),
    );
  }
}
