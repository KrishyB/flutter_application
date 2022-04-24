import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'input_page.dart';
import 'dart:io' show Platform;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Sākums'),
        '/input': (context) => const InputPage(title: 'Ievade'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  var statuss = List<int>.filled(50000, 0, growable: false);

  void change(int id) {
    setState(() {
      if (statuss[id] == 1) {
        statuss[id] = 0;
      } else {
        statuss[id] = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: widget.title,
      color: Colors.black,
      child: Scaffold(
        drawer: ((MediaQuery.of(context).size.width < 600) ? NavBar() : null),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Row(children: [
          NavList(),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: ListView(
                        primary: true,
                        children: List<ContextMenuArea>.generate(
                            50000,
                            ((int index) => ContextMenuArea(
                                builder: (context) => [
                                      SingleChildScrollView(
                                          primary: false,
                                          child: ListTile(
                                            title: const Text("Mainīt"),
                                            onTap: () {
                                              change(index);
                                              Navigator.of(context).pop();
                                            },
                                          ))
                                    ],
                                child: ListTile(
                                  title: (statuss[index] == 0)
                                      ? Text("${index + 1}. Virsraksts")
                                      : Text(
                                          "Mainīts ${index + 1}. Virsraksts"),
                                  subtitle: Text("Apraksts nr. ${index + 1}"),
                                ))))))
              ],
            ),
          )
        ])),
      ),
    );
  }
}
