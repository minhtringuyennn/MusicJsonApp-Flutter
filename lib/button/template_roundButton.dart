import 'package:flutter/material.dart';

class ButtonRound extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  ButtonRound({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return buildButton(text: text, onClicked: onPressed);
  }
}

Widget buildButton({required String text, required VoidCallback onClicked}) =>
    Container(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.green),
          color: Colors.green.shade400,
        ),
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                    child: Icon(Icons.mail, size: 40, color: Colors.white)),
                Container(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: onClicked,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
