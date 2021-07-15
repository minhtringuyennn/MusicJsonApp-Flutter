import 'package:flutter/material.dart';
import '../user.dart';

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.album),
      ),
    );
  }
}
