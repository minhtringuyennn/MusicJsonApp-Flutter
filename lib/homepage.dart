import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';

import 'dart:convert';

import './user.dart';
import './listdetail.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? data;
  Future<String> getJson() => rootBundle.loadString('assets/data.json');

  void _getUsers() async {
    var _data = json.decode(await getJson()) as List;
    List<User> users = _data.map((user) => User.fromJson(user)).toList();

    await Future.delayed(const Duration(seconds: 3));

    setState(() => data = users);
    print('done fetching');
  }

  void _addUser(String name, String album) {
    String picture = 'http://lorempixel.com/400/400/people';
    setState(() {
      data!.insert(data!.length, User(name, album, picture));
    });
  }

  void _writeJson(int index) {
    setState(() => data!.removeAt(index));
  }

  TextEditingController songNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  bool isSongNameValidate = true;
  bool isAuthorNameValidate = true;

  bool validateTextField(String userInput) {
    setState(
      () => {
        if (songNameController.text.isEmpty) isSongNameValidate = false,
        if (authorNameController.text.isEmpty) isAuthorNameValidate = false,
      },
    );

    return userInput.isNotEmpty;
  }

  void _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: 180,
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: songNameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Song Name',
                    hintText: 'eg. Never Gonna Give You Up',
                    errorText:
                        isSongNameValidate ? null : 'Please enter a song name.',
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: authorNameController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    hintText: 'eg. Rick Astley',
                    errorText: isAuthorNameValidate
                        ? null
                        : 'Please enter author name.',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('SAVE'),
            onPressed: () => {
              isSongNameValidate = validateTextField(songNameController.text),
              isAuthorNameValidate =
                  validateTextField(authorNameController.text),
              if (isSongNameValidate && isAuthorNameValidate)
                {
                  _addUser(authorNameController.text, songNameController.text),
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Song \"${songNameController.text}\" by \"${authorNameController.text}\" was added."),
                    ),
                  ),
                  Navigator.pop(context)
                }
            },
          ),
          TextButton(
            child: const Text('CANCLE'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: data == null
          ? Container(
              child: Center(
                child: LoadingBouncingGrid.square(
                  backgroundColor: Colors.red,
                  borderColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              ),
            )
          : Container(
              child: ListView.separated(
                itemCount: data!.length,
                separatorBuilder: (context, int index) => const Divider(
                    height: 2, thickness: 0.5, indent: 15, endIndent: 15),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(data![index].album),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Confirmation"),
                            content: const Text(
                                "Are you sure you want to delete this item?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Song \"${data![index].album}\" was removed."),
                        ),
                      );
                      _writeJson(index);
                    },
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(Icons.delete, color: Colors.white),
                      color: Colors.red.shade400,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(data![index].picture)),
                      title: Text(data![index].album),
                      subtitle: Text('By ${data![index].name}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(data![index])),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showDialog(),
      ),
    );
  }
}
