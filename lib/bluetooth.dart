// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/*
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_ble/flutter_ble.dart';
import 'package:bike_fitness/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FlutterBleApp extends StatefulWidget {
  FlutterBleApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterBleAppState createState() => new _FlutterBleAppState();
}

class _FlutterBleAppState extends State<FlutterBleApp> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FlutterBle _flutterBlue = FlutterBle.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  static const String CHARACTERISTIC_UUID =
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  static const String kMYDEVICE = "myDevice";
  String _myDeviceId;
  String _temperature = "?";
  String _humidity = "?";

  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBle
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });

    _loadMyDeviceId();
  }

  _loadMyDeviceId() async {
    SharedPreferences prefs = await _prefs;
    _myDeviceId = prefs.getString(kMYDEVICE) ?? "";
    print("_myDeviceId : " + _myDeviceId);

    if (_myDeviceId.isNotEmpty) {
      _startScan();
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 10),
      withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]
    )
        .listen((scanResult) {
      print('localName: ${scanResult.advertisementData.localName}');
      print(
         'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
     print('serviceData: ${scanResult.advertisementData.serviceData}');

      if (_myDeviceId == scanResult.device.id.toString()) {
        _stopScan();
        _connect(scanResult.device);
      }

      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
      null,
      onDone: _disconnect,
    );

    // Update the connection state immediately
    device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          setState(() {
            services = s;

            print("*** device.id : ${device.id.toString()}");

            _restoreDeviceId(device.id.toString());
            _TurnOnCharacterService();
          });
        });
      }
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device = null;
    });
  }

  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
    setState(() {});
  }

  _writeCharacteristic(BluetoothCharacteristic c) async {
    await device.writeCharacteristic(c, [0x12, 0x34],
        type: CharacteristicWriteType.withResponse);
    setState(() {});
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
    setState(() {});
  }

  _writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x12, 0x34]);
    setState(() {});
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        final decoded = utf8.decode(d);
        _DataParser(decoded);

//        setState(() {
//          print('onValueChanged $d');
//        });
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
    setState(() {});
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;
    setState(() {
      deviceState = state;
      print('State refreshed: $deviceState');
    });
  }

  _buildScanningButton() {
    if (isConnected || state != BluetoothState.on) {
      return null;
    }
    if (isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: _stopScan,
        backgroundColor: Colors.blueGrey[50],
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: _startScan);
    }
  }

  _buildScanResultTiles() {
    return scanResults.values
        .map((r) => ScanResultTile(
      result: r,
      onTap: () => _connect(r.device),
    ))
        .toList();
  }

  List<Widget> _buildServiceTiles() {
    return services
        .map(
          (s) => new ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => new CharacteristicTile(
            characteristic: c,
            onReadPressed: () => _readCharacteristic(c),
            onWritePressed: () => _writeCharacteristic(c),
            onNotificationPressed: () => _setNotification(c),
            descriptorTiles: c.descriptors
                .map(
                  (d) => new DescriptorTile(
                descriptor: d,
                onReadPressed: () => _readDescriptor(d),
                onWritePressed: () => _writeDescriptor(d),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  _buildActionButtons() {
    if (isConnected) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => _disconnect(),
        )
      ];
    }
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.blueGrey[50],
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  _buildDeviceStateTile() {
    return new ListTile(
        leading: (deviceState == BluetoothDeviceState.connected)
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        title: new Text('Device is ${deviceState.toString().split('.')[1]}.'),
        subtitle: new Text('${device.id}'),
        trailing: new IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refreshDeviceState(device),
          color: Theme.of(context).iconTheme.color.withOpacity(0.5),
        ));
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    if (isConnected) {
//      tiles.add(_buildDeviceStateTile());
//      tiles.addAll(_buildServiceTiles());
    } else {
      tiles.addAll(_buildScanResultTiles());
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Available Devices'),
          actions: _buildActionButtons(),
          backgroundColor: Colors.blueGrey[800],
          centerTitle: true,
        ),
        backgroundColor: Colors.blueGrey[50],
        floatingActionButton: _buildScanningButton(),
        body: new Stack(
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),
            isConnected
                ? _bulldMyWidget()
                : new ListView(
              children: tiles,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _restoreDeviceId(String id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(kMYDEVICE, id);
  }

  _TurnOnCharacterService() {
    services.forEach((service) {
      service.characteristics.forEach((character) {
        if (character.uuid.toString() == CHARACTERISTIC_UUID) {
          _setNotification(character);
        }
      });
    });
  }

  _bulldMyWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: Container(
              width: 150,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('images/temperature.png'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Temperature",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    _temperature,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              width: 150,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('images/humidity.png'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Humidity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    _humidity,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _DataParser(String data) {
    if (data.isNotEmpty) {
      var tempValue = data.split(",")[0];
      var humidityValue = data.split(",")[1];

      print("tempValue: ${tempValue}");
      print("humidityValue: ${humidityValue}");

      setState(() {
        _temperature = tempValue + "'C";
        _humidity = humidityValue + "%";
      });
    }
  }
}
*/
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:bike_fitness/widgets.dart';

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
        accentColor: Colors.yellow[700],
        backgroundColor:  Colors.blueGrey[50],
      ),

      home: StreamBuilder<BluetoothState>(

          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);

          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Devices')),
      backgroundColor: Colors.blueGrey[50],
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                    title: Text(d.name),
                    subtitle: Text(d.id.toString()),
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                      builder: (c, snapshot) {
                        if (snapshot.data ==
                            BluetoothDeviceState.connected) {
                          return RaisedButton(
                            child: Text('OPEN'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceScreen(device: d))),
                          );
                        }
                        return Text(snapshot.data.toString());
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.pink[700],
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () => c.read(),
            onWritePressed: () async {
              await c.write(_getRandomBytes(), withoutResponse: true);
              await c.read();
            },
            onNotificationPressed: () async {
              await c.setNotifyValue(!c.isNotifying);
              await c.read();
            },
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () => d.read(),
                onWritePressed: () => d.write(_getRandomBytes()),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
