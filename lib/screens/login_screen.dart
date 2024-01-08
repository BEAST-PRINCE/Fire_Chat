import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/components/rounded_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import 'chat_screen.dart';


class LoginScreen extends StatefulWidget {
  static const id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;

  bool spinner = false;

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero( tag: 'firelogo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Password")
              ),
              const SizedBox(
                height: 24.0,
              ),
          RoundedButtons(title: 'Log In', colour: Colors.lightBlueAccent,
              func: () async{
                setState(() {
                  spinner = true;
                });
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }catch(e){
                  print(e);
                }

                setState(() {
                  spinner = false;
                });
              }),

        ]),
        ),
      ),
    );
  }
}
