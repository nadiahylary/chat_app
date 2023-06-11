import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _kFirebaseAuth = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              )
          ),
        ],
      ),
      body: Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}
