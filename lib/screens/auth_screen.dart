import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _kFirebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredUsername = '';
  String _enteredPass = '';
  var _isLogin = true;
  File? _userImageFile;
  var _isAuthenticating = false;

  void _submitAuth() async {
    var isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _userImageFile == null) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        //fetching user credentials and authenticate
        final userCredentials = await _kFirebaseAuth.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
      } else {
        //create new user and authenticating with firebase auth
        final userCredentials = await _kFirebaseAuth.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);

        //creating and saving user profile images in firebase_storage on signup
        final imageStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_images')
            .child('${userCredentials.user!.uid}.jpg');

        await imageStorageRef.putFile(_userImageFile!);
        final userProfileImageUrl = await imageStorageRef.getDownloadURL();
        print(userProfileImageUrl);

        //creating and saving users data on cloud_firestore on signup
        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'imageUrl': userProfileImageUrl
        });

      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content: Text(error.message ?? "Authentication Failed. Please try again."),
        )
      );
      setState(() {
        _isAuthenticating = false;
      });
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
                              labelText: "email",
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
                          if(!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "username",
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 5) {
                                return 'Username should be at least 5 characters.';
                              }
                              return null;
                            },
                            onSaved: (username) {
                              _enteredUsername = username!;
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
                            height: 30,
                          ),
                          if(_isAuthenticating)
                            const Center(child: CircularProgressIndicator(),),
                          if(!_isAuthenticating)
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
                          if(!_isAuthenticating)
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
