import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SavingReadingFile(),
    );
  }
}

class SavingReadingFile extends StatefulWidget {
  const SavingReadingFile({Key? key}) : super(key: key);

  @override
  State<SavingReadingFile> createState() => _SavingReadingFileState();
}

class _SavingReadingFileState extends State<SavingReadingFile> {
  final TextEditingController _textController = TextEditingController();

  static const String kLocalFileName = 'demo_localfile.txt';

  String _localFileContent = '';
  String _localFilePath = kLocalFileName;

  @override
  @override
  void initState() {
    super.initState();
    this._readTextFromLocalFile();
    this
        ._getLocalFile
        .then((file) => setState(() => this._localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text('Local file save/read'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text('Write to local file:', style: TextStyle(fontSize: 20.0)),
          TextField(
            focusNode: textFieldFocusNode,
            controller: _textController,
            maxLines: null,
            style: TextStyle(fontSize: 20.0),
          ),
          ButtonBar(
            children: [
              MaterialButton(
                onPressed: () async {
                  this._readTextFromLocalFile();
                  this._textController.text = this._localFileContent;
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log('String successfully loaded from local file');
                },
                child: Text('Load', style: TextStyle(fontSize: 20.0)),
              ),
              MaterialButton(
                onPressed: () async {
                  await this._writeTextToLocalFile(this._textController.text);
                  this._textController.clear();
                  await this._readTextFromLocalFile();
                  log('String successfully writen lo local file');
                },
                child: Text('Save', style: TextStyle(fontSize: 20.0)),
              ),
              Divider(height: 20.0),
              Text('Local file path',
                  style: Theme.of(context).textTheme.headline6),
              Text(this._localFilePath,
                  style: Theme.of(context).textTheme.subtitle1),
              Divider(height: 20.0),
              Text('Local file content:',
                  style: Theme.of(context).textTheme.headline6),
              Text(this._localFileContent,
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          )
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/$kLocalFileName');
  }

  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }

  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent = content;
    });
  }
}
