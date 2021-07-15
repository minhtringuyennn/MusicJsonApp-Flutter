import 'package:flutter/material.dart';

class ButtonModal extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ButtonModal({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return buildButton(text: text, onClicked: onPressed);
  }
}

Widget buildButton({required String text, required VoidCallback onClicked}) =>
    Container(
      padding: EdgeInsets.all(8),
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(229, 13, 115, 1),
                Color.fromRGBO(247, 98, 7, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: GestureDetector(
              onTap: onClicked,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
