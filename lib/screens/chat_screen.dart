import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_messages.dart';
import '../widgets/new_messages.dart';

final _kFirebaseAuth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async{
    final kFirebaseMsg = FirebaseMessaging.instance;

    await kFirebaseMsg.requestPermission();
    /*final token = await kFirebaseMsg.getToken(); // device id to send a notification to a specific device
    print(token);*/
    kFirebaseMsg.subscribeToTopic('group-chat'); //sending notification to all devices running the app

  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                _kFirebaseAuth.signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              )
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: const ChatMessages()
          ),
          const NewMessage(),
        ],
      )
    );
  }

}
