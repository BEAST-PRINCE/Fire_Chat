import 'package:flutter/material.dart';

class RoundedButtons extends StatelessWidget{

  RoundedButtons({required this.title, required this.colour, required this.func});


  late final Color colour;
  late final String title;
  late final Function func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: (){func();},
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}