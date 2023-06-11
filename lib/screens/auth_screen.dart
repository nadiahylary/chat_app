import 'dart:io';

import 'package:chat_app/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _kFirebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPass = '';
  var _isLogin = true;
  File? _userImageFile;

  void _submitAuth() async {
    var isValid = _form.currentState!.validate();
    if (!isValid || !_isLogin && _userImageFile == null) {
      return;
    }
    _form.currentState!.save();

    try {
      if (_isLogin) {
        //fetch user and authenticate
        final userCredentials = await _kFirebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
      } else {
        //create new user and authenticate
        final userCredentials = await _kFirebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
        final imageStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_images')
            .child('${userCredentials.user!.uid}.jpg');

        imageStorageRef.putFile(_userImageFile!);
        final userProfileImageUrl = await imageStorageRef.getDownloadURL();
        print(userProfileImageUrl);
        
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        //duration: const Duration(seconds: 3),
        content:
            Text(error.message ?? "Authentication Failed. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: _isLogin
                    ? const EdgeInsets.only(top: 25, left: 20, right: 20)
                    : const EdgeInsets.only(top: 10, left: 20, right: 20),
                width: 300,
                child: Image.asset("assets/images/chat_icon.png"),
              ),
              Card(
                elevation: 6,
                margin: _isLogin
                    ? const EdgeInsets.symmetric(vertical: 20, horizontal: 30)
                    : const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickedImage: (userImage) {
                                _userImageFile = userImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "email or username",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.trim().contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (email) {
                              _enteredEmail = email!;
                            },
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "password",
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password should be >= 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (password) {
                              _enteredPass = password!;
                            },
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: _submitAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            child: Text(
                              _isLogin ? "Login" : "Signup",
                              style: GoogleFonts.balthazar(
                                textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? "Sign up instead."
                                  : "I already have an account.",
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
