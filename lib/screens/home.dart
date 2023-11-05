import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:sms/constants/message.dart';

import 'package:sms/helpers/db_instanse.dart';
import 'package:sms/helpers/time_getter.dart';
import 'package:sms/screens/chat.dart';

import 'package:sms/widgets/home_header.dart';
import 'package:sms/widgets/sliver_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>>? chatsList;
  final TextEditingController textControllerContact = TextEditingController();
  final TextEditingController textControllerMessage = TextEditingController();
  final RandomColor randomColor = RandomColor();

  Future<void> getAllChats() async {
    final List<Map<String, String>> chats =
        await DatabaseHelper.instance.fetchAllChatNamesWithLastMessage();

    // Update state with the new chats list
    setState(() {
      chatsList = chats;
    });
  }

  @override
  void initState() {
    super.initState();

    getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: chatsList == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  const HomeHeader(),
                  if (chatsList!.isEmpty)
                    SliverFillRemaining(
                      child: Container(color: Colors.white),
                    )
                  else
                    SliverChat(
                      chatsList: chatsList,
                      randomColor: randomColor,
                    ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: Icon(Icons.sms_rounded,
              color: Colors.white,
              size: Theme.of(context).floatingActionButtonTheme.iconSize),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Начать диалог'),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: textControllerContact,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            hintText: 'Получатель',
                          ),
                        ),
                        TextField(
                          controller: textControllerMessage,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            hintText: 'Сообщение',
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Oтменить'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .createChat(textControllerContact.text);
                        await DatabaseHelper.instance.sendMessage(
                            textControllerMessage.text,
                            Message(textControllerMessage.text, true,
                                getCurrentHoursMinutes()));
                        getAllChats(); // Refresh chats list
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                title: textControllerContact
                                    .text))); // Close the dialog
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
