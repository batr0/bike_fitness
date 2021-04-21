import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:bike_fitness/dataparser.dart';
import 'package:latlong/latlong.dart';
import 'package:bike_fitness/widgets/map_elevation.dart';
import '../../dataparser.dart';
import '../../graphs.dart';

dynamic  parsed = [];
Stopwatch duration = new Stopwatch();

Stream<String> speedStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[5]; //speed
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> durationStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    String _printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return _printDuration((duration.elapsed)).toString();
  });
  speedStream().asBroadcastStream();
}

Stream<String> rpmStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[15]; //speed
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> inTempStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    var c = double.parse(parsed[17]).toDouble();
    double f = c * (9/5)+32;
    return f.toStringAsFixed(0); //speed
  });
  speedStream().asBroadcastStream();
} //done

Stream<String> extTempStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    var c = double.parse(parsed[14]).toDouble();
    double f = c;
    return f.toStringAsFixed(0); //speed0
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> altStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    var alt = double.parse(parsed[6]).toDouble();
    double ele = alt;
    return ele.toStringAsFixed(0);//speed
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> accelStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[19]; //speed
  });
  speedStream().asBroadcastStream();
}

Stream<String> satStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[16]; //speed
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> cardStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[7]; //speed
  });
  speedStream().asBroadcastStream();
}//done

Stream<String> powerStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    var x = double.parse(parsed[5]).toDouble();
    if(x<2.9){
      return 0.toString();
    }
    else{
      double y =  2.4974*log(x) - 2.643;
        return y.toStringAsFixed(2);
      //speed
    }});
  speedStream().asBroadcastStream();
} //done

Stream<String> tempStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    return parsed[14]; // temperature
  });
  tempStream().asBroadcastStream();
}//done

Stream<String> gpsStream() async* {
  yield* Stream.periodic(Duration(milliseconds: 10), (int a) {
    var lat=double.parse(parsed[3]).toDouble();
    var long=double.parse(parsed[4]).toDouble();
    var vel=double.parse(parsed[5]).toDouble();
    var z=double.parse(parsed[6]).toDouble();

    int flag = 0;

    if((lat*long)==0){
      //The it is not working - no connection case
      flag  = 1;
    }
    if ((lat == lat_compare) || (long == long_compare)) {
      //Repeated in mem case
      flag = 2;
    }
    // print(lat);
    // print(lat_compare);
    if(flag < 1) {

      sensData2.add(LatLng(lat, long)); // add gps points to polyline data
      elevData.add(ElevationPoint(lat, long, z));// add gps points + elevation data for z data parsing
      velData.add(ElevationPoint(lat, long, vel));// add gps points + speed  data for z data parsing / mapping

      lat_compare = lat;
      long_compare = long; //update 'mem'
      print('New Data Point!');
    } else{
      //We do not want this going into memory! eh
    }
    // print(flag);


    //Need to get the distance
    if(flag == 1) {
      //DO NOT DO DIS CALC
    }else{
      distCalc();
    }

    //Return regardless of Exisiting Case...
    totalDistanceInM = totalDistanceInM * .000621371; // conversions
    return totalDistanceInM.toStringAsFixed(2); // temperaturre // 2 sig figs

  });
  tempStream().asBroadcastStream();
}//done

//set the

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });

    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = false;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                    (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    if(messages != null && messages.length > 0){    // error catching no more bad state before the list is populated
      var serialData = (messages.last.text.replaceAll("	" , " ").replaceAll(",", " ").toString());
      data2Double.add(serialData);
      parsed = data2Double.last.split(" ");

      csv.add(parsed);
      csv2.add(csv);
    }

    // array of separated strings
    double tempDist = 0; // reset the distance for calculations

    // get rid of tabs and commas, to stri
    totalDistanceInM = tempDist;
    //debugPrint("D~"+ sensData2.toString());
    //debugPrint("D~" + parsed.toString());

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //This is the TOP level - MPH, Miles, Duration
            Container(
              height: 150,
              width: 1000,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Column(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                child: StreamBuilder<String>(
                                  stream: speedStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "MPH",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 30),
                            ),
                          ),
                        ])),
                  ),
                  Container(
                    child: Card(
                      color: Colors.grey,
                    ),
                    height:200,
                    width:10,
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Column(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                child: StreamBuilder<String>(
                                  stream: gpsStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "Miles",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 30),
                            ),
                          ),
                        ])),
                  ),
                  Container(
                    child: Card(
                      color: Colors.grey,
                    ),
                    height:200,
                    width:10,
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Column(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                child: StreamBuilder<String>(
                                  stream: durationStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "Duration",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 30),
                            ),
                          ),
                        ])),
                  ),
                ],
              ),
            ),//speed mph
            Container(
              child: Card(
                color: Colors.grey,
              ),
              height:20,
              width:1000,
            ),
            //This is the MID - Temp, RPM, Watts
            Container(
              height: 100,
              width: 1000,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: 100,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                child: StreamBuilder<String>(
                                  stream: powerStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "Watts",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 28),
                            ),
                          ),
                        ])),
                  ),
                  Container(
                    child: Card(
                      color: Colors.grey,
                    ),
                    height:200,
                    width:10,
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                child: StreamBuilder<String>(
                                  stream: rpmStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                )),
                          ),
                          Expanded(
                            child: Text(
                              "RPM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 28),
                            ),
                          ),
                        ])),
                  ),
                ],
              ),
            ), // power
            Container(
              child: Card(
                color: Colors.grey,
              ),
              height:20,
              width:1000,
            ),
            //This is the MESS....
            Container(
              height: 50,
              width: 1000,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: 100,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: inTempStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Internal Temp",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ),
                        ])),
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              "External Temp",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: extTempStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                        ])),
                  ),//external
                ],
              ),
            ), // internal temp
            Container(
              height: 50,
              width: 1000,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: 100,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: altStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Altitude",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ),
                        ])),
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              "Accel.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: accelStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                        ])),
                  ),//acceleration
                ],
              ),
            ), // altitude
            Container(
              height: 50,
              width: 1000,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        height: 100,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: satStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Satellite Con.s",
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ), //satellite connection
                        ])),
                  ),
                  Expanded(
                    child: Container(
                        height: 120,
                        width: 1,
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              "Card. Direction",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueGrey[50], fontSize: 25),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height:100,
                              width: 2,
                              child: FittedBox(
                                child: StreamBuilder<String>(
                                  stream: cardStream(),
                                  initialData: '0',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                          child: CircularProgressIndicator(),
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(10));
                                    } else if (snapshot.hasError) {
                                      return Text("Error");
                                    } else {
                                      return Text(snapshot.data,
                                          style: TextStyle(
                                              color: Colors.yellow[700]));
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                        ])),
                  ), //card Direction
                ],
              ),
            ),//satellite
            Container(
              child: Card(
                color: Colors.grey,
              ),
              height:20,
              width:1000,
            ),


            Wrap(
              spacing: 35,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(5.0),
                  color: Colors.blueGrey[300],
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.stop, size: 45),
                      Text('End Ride', textScaleFactor: 1.25),
                    ],
                  ),
                  onPressed: () => [_sendMessage('b'),duration.stop()],
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(5.0),
                  color: Colors.blueGrey[300],
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.trip_origin, size: 45),
                      Text('Reset Data', textScaleFactor: 1.25),
                    ],
                  ),
                  onPressed: () => [reset(parsed),duration.reset()],
                ),
                //reset button
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(5.0),
                  color: Colors.blueGrey[300],
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.send, size: 45),
                      Text('Start Ride', textScaleFactor: 1.25),
                    ],
                  ),
                  onPressed: () => [_sendMessage('h'), duration.start()],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                            ? 'Connection Established'
                            : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(10);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}