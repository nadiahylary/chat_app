import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _submitAuth() {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if(_isLogin) {
      //fetch user and authenticate
    } else{
      //create new user and authenticate
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                width: 300,
                child: Image.asset("assets/images/chat_icon.png"),
              ),
              Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "email or username",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value){
                              if(value == null || value.trim().isEmpty || !value.trim().contains('@')){
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (email){
                              _enteredEmail = email!;
                            },
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "password",
                            ),
                            obscureText: true,
                            validator: (value){
                              if(value == null || value.trim().length < 6){
                                return 'Password should be >= 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (password){
                              _enteredPass = password!;
                            },
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                            onPressed: _submitAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                            child: Text(
                              _isLogin ? "Login" : "Signup" ,
                              style: GoogleFonts.balthazar(
                                textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            onPressed: (){
                              setState(() {
                               _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                                _isLogin ? "Sign up instead.": "I already have an account.",
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary
                                ),
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
