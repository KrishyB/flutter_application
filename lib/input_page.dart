import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'nav_bar.dart';
import 'package:sensors_plus/sensors_plus.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputPage> {
  double value1 = 0;
  double value2 = 0;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _streamSubscriptions.add(gyroscopeEvents.listen((event) {
          if (kDebugMode) {
            print(event);
          }
          value1 = event.x * 10;
          value2 = event.y * 10;

          if (value1 > 100) {
            value1 = 100;
          }
          if (value1 < -100) {
            value1 = -100;
          }
          if (value2 > 100) {
            value2 = 100;
          }
          if (value2 < -100) {
            value2 = -100;
          }
          setState(() {});
        }));
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

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
                child: ListView(
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
                            padding: const EdgeInsets.all(10.0),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Text(value2.toStringAsFixed(2))),
                      ],
                    ),
                    (kIsWeb)
                        ? const FileUpload()
                        : (Platform.isAndroid)
                            ? const CameraModule()
                            : Container(),
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
    //ja ir web platforma
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
              .bytes;
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

class CameraModule extends StatefulWidget {
  const CameraModule({Key? key}) : super(key: key);

  @override
  CameraModuleState createState() => CameraModuleState();
}

class CameraModuleState extends State<CameraModule> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final CameraDescription mainCamera = cameras.first;
  String? attels;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      mainCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;

              final result = await _controller.takePicture();
              setState(() {
                attels = result.path;
              });
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          child: const Text("Uzņemt attēlu")),
      FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      (attels != null) ? Image.file(File(attels as String)) : Container()
    ]);
  }
}
