import 'package:bike_fitness/btserial/example/ChatPage.dart';
import 'package:bike_fitness/csv/lib/loadCsvDataScreen.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../dataparser.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'allCsv.dart';


class csvStorage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Csv Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
        accentColor: Colors.yellow[700],
        backgroundColor:  Colors.blueGrey[50],
      ),
      home: MyHomePage(title: 'Flutter Csv Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AllCsvFilesScreen()));
              },
              color: Colors.yellow[700],
              child: Text("Load all csv form phone storage"),
            ),
            MaterialButton(
              onPressed: () {
                loadCsvFromStorage();
              },
              color: Colors.yellow[700],
              child: Text("Load csv form phone storage"),
            ),
            MaterialButton(
              onPressed: () {
                generateCsv(csv2);
              },
              color: Colors.yellow[700],
              child: Text("Load Created csv"),
            ),
          ],
        ),
      ),
    );
  }

  generateCsv(List<List<dynamic>> data) async {
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path);
        },
      ),
    );
  }

  loadCsvFromStorage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String path = result.files.first.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path);
        },
      ),
    );
  }
}
