import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Music List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? data;

  Future<String> getJson() {
    return rootBundle.loadString('assets/data.json');
  }

  void _getUsers() async {
    var _data = await getJson();

    var userList = json.decode(_data) as List;

    List<User> users = userList.map((user) => User.fromJson(user)).toList();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      data = users;
    });

    print('done');
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
              child: ListView.builder(
                itemCount: data!.length,
                itemBuilder: (BuildContext, index) {
                  return Dismissible(
                    key: new Key(data![index].album),
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
                                  child: const Text("Delete")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
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
                      setState(() {
                        data!.removeAt(index);
                        print(json.encode(data));
                      });
                    },
                    background: new Container(
                      color: Colors.red.shade300,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data![index].picture),
                      ),
                      title: Text(
                        data![index].album,
                      ),
                      subtitle: Text(
                        'By ${data![index].name}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => DetailPage(data![index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

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

class User {
  final int index;
  final String name;
  final String album;
  final String picture;

  User(
    this.index,
    this.name,
    this.album,
    this.picture,
  );

  factory User.fromJson(dynamic json) {
    return User(
      json['index'] as int,
      json['name'] as String,
      json['album'] as String,
      json['picture'] as String,
    );
  }

  Map<String, dynamic> toJson() => 
  {
    'index': index,
    'name': name,
    'album': album,
    'picture': picture,
  };
}
