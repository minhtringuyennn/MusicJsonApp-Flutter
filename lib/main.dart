import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

    var jsonData = json.decode(_data);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(
        u["index"],
        u["name"],
        u["album"],
        u["picture"],
      );

      users.add(user);
    }

    await Future.delayed(const Duration(seconds: 2));

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
    if (data == null) {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: LoadingBouncingGrid.square(
              backgroundColor: Colors.red,
              borderColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          ),
        ),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: data!.length,
            itemBuilder: (BuildContext, index) {
              return Slidable(
                key: ValueKey(index),
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red.shade300,
                      icon: Icons.remove_circle,
                      closeOnTap: true,
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: 'Delete on ${index}',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      })
                ],
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
}
