import 'dart:io';

import 'package:camera/camera.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'input_page.dart';

List<CameraDescription> cameras = List.empty(growable: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      cameras = await availableCameras();
    }
  }

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
  var statuss = List<int>.filled(5000, 0, growable: false);

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
            child: Row(
          children: [
            NavList(),
            Expanded(flex: 1, child: generateList(500)),
          ],
        )),
      ),
    );
  }

  ListView generateList(skaits) {
    if (kIsWeb) {
      return ListView(
          children: List<ContextMenuArea>.generate(
              skaits,
              ((int index) => ContextMenuArea(
                  builder: (context) => [
                        ListTile(
                          title: const Text('Mainīt'),
                          onTap: () {
                            Navigator.of(context).pop();
                            change(index);
                          },
                        )
                      ],
                  child: ListTile(
                    title: (statuss[index] == 0)
                        ? Text("${index + 1}. Virsraksts")
                        : Text("Mainīts ${index + 1}. Virsraksts"),
                    subtitle: Text("Apraksts nr. ${index + 1}"),
                  )))));
    } else {
      return ListView(
          children: List<Row>.generate(
              skaits,
              (index) => Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: ListTile(
                            title: (statuss[index] == 0)
                                ? Text("${index + 1}. Virsraksts")
                                : Text("Mainīts ${index + 1}. Virsraksts"),
                            subtitle: Text("Apraksts nr. ${index + 1}"),
                          )),
                      PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Text("Mainīt"),
                                  onTap: () {
                                    change(index);
                                  },
                                ),
                              ]),
                    ],
                  )));
    }
  }
}
