import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:sms/screens/chat.dart';
import 'package:sms/widgets/chat_item/chat_item_user_icon.dart';

class SliverChat extends StatelessWidget {
  const SliverChat(
      {super.key, required this.chatsList, required this.randomColor});

  final List<Map<String, String>>? chatsList;
  final RandomColor randomColor;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final chat = chatsList![index];
          return Column(
            children: [
              SizedBox(
                height: 70,
                child: ListTile(
                  leading: ChatItemUserIcon(randomColor: randomColor),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(title: chat['chatName']!)));
                  },
                  title: Text(
                    chat['chatName']?.substring(4) ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    chat['lastMessage'] ?? '',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              if (index != chatsList!.length - 1) // If it's not the last item
                Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(74, 8, 24, 8),
                    child: Divider(
                      height: 2,
                      color: Color.fromRGBO(209, 209, 209, 1),
                    ),
                  ),
                ),
            ],
          );
        },
        childCount: chatsList!.length,
      ),
    );
  }
}
