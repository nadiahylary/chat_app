import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _kFirebase = FirebaseAuth.instance;

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
