import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'nav_bar.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  double value1 = 0;
  double value2 = 0;

  @override
  Widget build(BuildContext context) {
    return Title(
        color: Colors.black,
        title: widget.title,
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
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Slider(
                                value: value1,
                                max: 100,
                                min: -100,
                                onChanged: (double value) {
                                  setState(() {
                                    value1 = value;
                                  });
                                })),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(value1.toStringAsFixed(2))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Slider(
                                value: value2,
                                max: 100,
                                min: -100,
                                onChanged: (double value) {
                                  setState(() {
                                    value2 = value;
                                  });
                                })),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(value2.toStringAsFixed(2))),
                      ],
                    ),
                    FileUpload(),
                  ],
                ))
          ])),
        ));
  }
}

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  FileUploadState createState() => FileUploadState();
}

class FileUploadState extends State<FileUpload> {
  Uint8List? attels;
  String virsraksts = "Izvēlēties";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(virsraksts),
        onTap: () async {
          Uint8List? file = (await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: false,
          ))
              ?.files
              .first
              .bytes as Uint8List;
          setState(() {
            attels = file;
          });
        },
      ),
      (attels != null)
          ? Image.memory(
              attels as Uint8List,
              fit: BoxFit.fill,
            )
          : Container(
              width: 0,
            )
    ]);
  }
}
