import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final String path;

  LoadCsvDataScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV DATA"),
      ),
      body: FutureBuilder(
        future: loadingCsvData(path),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot.data.toString());
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: snapshot.data
                        .map(
                          (data) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  data.toString(),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = new File(file.path).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      print(fields);
    }
  }
  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(),
        )
        .toList();
  }
}
