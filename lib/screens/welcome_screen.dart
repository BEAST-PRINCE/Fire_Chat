import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/components/rounded_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation bg_animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    bg_animation = ColorTween(begin: Colors.blue, end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'firelogo',
                  child: Container(
                    height: 70,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                AnimatedTextKit( repeatForever: true,
                  animatedTexts: [TypewriterAnimatedText('Fire Chat',
                      textStyle: TextStyle(
                        color: Colors.amber[900],
                        fontSize: 55.0,
                        fontWeight: FontWeight.w900,
                      ),
                    speed: Duration(milliseconds: 400)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButtons(title: 'Log In', colour: Colors.lightBlueAccent, func: (){Navigator.pushNamed(context, LoginScreen.id);}),
            RoundedButtons(title: 'Register', colour: Colors.blueAccent, func: (){Navigator.pushNamed(context, RegistrationScreen.id);}),

          ],
        ),
      ),
    );
  }
}



