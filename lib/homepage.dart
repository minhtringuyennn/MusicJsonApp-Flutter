import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:io';

import './user.dart';
import './listdetail.dart';
import './template_button.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User>? data;
  File? jsonFile;
  Directory? dir;
  String fileName = "list_data.json";
  bool fileExists = false;

  TextEditingController songNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  bool isSongNameValidate = true;
  bool isAuthorNameValidate = true;

  Future<String> getJson() => rootBundle.loadString('assets/data.json');

  void _getSongList() async {
    var _data = json.decode(await getJson()) as List;
    List<User> users = _data.map((user) => User.fromJson(user)).toList();

    await Future.delayed(const Duration(seconds: 3));

    setState(() => data = users);
    print('done fetching');
  }

  void _addSong(String name, String album) {
    String picture = 'http://lorempixel.com/400/400/people';
    setState(() {
      data!.insert(data!.length, User(name, album, picture));
    });
    _writeToFile();
  }

  void _deleteSong(int index) {
    setState(() => data!.removeAt(index));
    _writeToFile();
  }

  void _createFile(Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(data));
  }

  void _writeToFile() {
    print("Writing to file!");

    if (fileExists) {
      print("File exists");
      jsonFile!.writeAsStringSync(json.encode(data));
    } else {
      print("File does not exist!");
      _createFile(dir!, fileName);
    }
    //this.setState(() => _getSongList());
    print(data![data!.length - 1].album);
  }

  bool _validateText(String userInput) {
    setState(
      () => {
        if (songNameController.text.isEmpty) isSongNameValidate = false,
        if (authorNameController.text.isEmpty) isAuthorNameValidate = false,
      },
    );

    return userInput.isNotEmpty;
  }

  void _showDialog() async => await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content:
              Container(height: 180, child: Column(children: _dialogSongAdd())),
          actions: _dialogSongConfirm(context),
        ),
      );

  List<Widget> _dialogSongAdd() {
    return <Widget>[
      Expanded(
        child: TextField(
          controller: songNameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Song Name',
            hintText: 'eg. Never Gonna Give You Up',
            errorText: isSongNameValidate ? null : 'Please enter a song name.',
          ),
        ),
      ),
      Expanded(
        child: TextField(
          controller: authorNameController,
          decoration: InputDecoration(
            labelText: 'Author',
            hintText: 'eg. Rick Astley',
            errorText:
                isAuthorNameValidate ? null : 'Please enter author name.',
          ),
        ),
      ),
    ];
  }

  List<Widget> _dialogSongConfirm(BuildContext context) {
    return <Widget>[
      TextButton(
        child: const Text('SAVE'),
        onPressed: () => {
          isSongNameValidate = _validateText(songNameController.text),
          isAuthorNameValidate = _validateText(authorNameController.text),
          if (isSongNameValidate && isAuthorNameValidate)
            {
              _addSong(authorNameController.text, songNameController.text),
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
    ];
  }

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      _getSongList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: data == null
          ? _loadScreen()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    text: "Show your favorite song",
                    onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => _buildSheet(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showDialog(),
      ),
    );
  }

  Widget _buildSheet() => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.84,
        maxChildSize: 0.85,
        builder: (_, controller) => _listBuild(controller),
      );

  Container _loadScreen() {
    return Container(
      child: Center(
        child: LoadingBouncingGrid.square(
          backgroundColor: Colors.red,
          borderColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      ),
    );
  }

  Container _listBuild(ScrollController controller) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView.separated(
        controller: controller,
        itemCount: data!.length,
        separatorBuilder: (context, int index) =>
            const Divider(height: 2, thickness: 0.5, indent: 15, endIndent: 15),
        itemBuilder: _songBuild,
      ),
    );
  }

  Widget _songBuild(context, index) {
    return Dismissible(
      key: Key(data![index].album),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Confirmation"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
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
            content: Text("Song \"${data![index].album}\" was removed."),
          ),
        );
        _deleteSong(index);
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(Icons.delete, color: Colors.white),
        color: Colors.red.shade400,
      ),
      child: ListTile(
        leading:
            CircleAvatar(backgroundImage: NetworkImage(data![index].picture)),
        title: Text(data![index].album),
        subtitle: Text('By ${data![index].name}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(data![index])),
          );
        },
      ),
    );
  }
}
