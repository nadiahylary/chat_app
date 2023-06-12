import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';
import '../screens/loading_screen.dart';

final _kFirebaseFirestore = FirebaseFirestore.instance;

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: _kFirebaseFirestore.collection('chats').orderBy('createdAt', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const LoadingScreen();
        }
        if(!snapshot.hasData || snapshot.data.docs.isEmpty){
          return const Center(
            child: Text("No messages yet..."),
          );
        }
        if(snapshot.hasError){
          return const Center(
            child: Text("Uh oh! Something went wrong..."),
          );
        }
        final loadedMsgs = snapshot.data.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
          reverse: true,
          itemBuilder: (ctx, index) {
            final chatMsg = loadedMsgs[index].data();
            final nextChatMsg = index + 1 < loadedMsgs.length ? loadedMsgs[index + 1].data() : null;
            final msgUserId = chatMsg['userId'];
            final nextMsgUserId = nextChatMsg != null ? nextChatMsg['userId'] : null;
            final nextUserIsSame = msgUserId == nextMsgUserId;
            if(nextUserIsSame){
              return MessageBubble.next(
                  message: chatMsg['message'],
                  isMe: currentUser.uid == msgUserId
              );
            } else {
              return MessageBubble.first(
                  userImage: chatMsg['userImage'],
                  username: chatMsg['username'],
                  message: chatMsg['message'],
                  isMe: currentUser.uid == msgUserId
              );
            }
          },
          itemCount: loadedMsgs.length,
        );
      },
    );
  }
}
