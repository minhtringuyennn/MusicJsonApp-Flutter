import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Music List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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

  void _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              Flexible(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Song Name',
                      hintText: 'eg. Never Gonna Give You Up'),
                ),
              ),
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Author', hintText: 'eg. Rick Astley'),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: const Text('CANCLE'),
              onPressed: () {
                Navigator.pop(context);
              })
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
                  height: 2,
                  thickness: 0.5,
                  indent: 15,
                  endIndent: 15,
                ),
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
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      color: Colors.red.shade400,
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
                          MaterialPageRoute(
                            builder: (context) => DetailPage(data![index]),
                          ),
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

  Map<String, dynamic> toJson() => {
        'index': index,
        'name': name,
        'album': album,
        'picture': picture,
      };
}
