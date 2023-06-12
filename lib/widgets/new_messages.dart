import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _submitMessage() async{
    //gat and validate the entered message
    final enteredMsg = _msgController.text;
    if(enteredMsg.trim().isEmpty){
      return;
    }
    //remove the focus on the input field
    FocusScope.of(context).unfocus();

    //clear the text field
    _msgController.clear();

    //send to firebase:

    //1- get currentUser from firebase_auth
    final currentUser = FirebaseAuth.instance.currentUser!;

    //2-get currentUser's data(username, image, etc) from cloud_firestore
    final currentUserData = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

    //3-add new document of chat data to the chats collection in cloud_firestore
    FirebaseFirestore.instance.collection('chats').add({
      'message': enteredMsg,
      'userId': currentUser.uid,
      'username': currentUserData.data()!['username'],
      'userImage': currentUserData.data()!['imageUrl'],
      'createdAt': Timestamp.now(),
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: (){},
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.emoji_emotions,
                size: 25,
              )
          ),
          Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: "Message"
                ),
                controller: _msgController,
              ),
          ),
          IconButton(
              onPressed: _submitMessage,
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.send,
                size: 25,
              )
          )
        ],
      ),
    );
  }
}
