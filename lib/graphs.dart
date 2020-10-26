import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bike_fitness/boxes.dart';



class speedGraph extends StatefulWidget {
  speedGraph({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _speedGraphState createState() => _speedGraphState();
}

class PowerData {
  final int  time;
  final double watt;
  final charts.Color color;

  PowerData(this.time, this.watt, Color color)
  :this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class LiveData {
  final String title;
  final double input;
  final charts.Color color;

  LiveData(this.title, this.input, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _speedGraphState extends State<speedGraph> {
  var _spd = BoxSpeed.spd;

  @override
  Widget build(BuildContext context) {
    var data = [
      LiveData('', BoxSpeed.spd, Colors.yellow[700]),
    ];

    var series = [
      charts.Series(
        domainFn: (LiveData clickData, _) => clickData.title,
        colorFn: (LiveData clickData, _) => clickData.color,
        measureFn: (LiveData , _) => 100,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.PieChart(
      series,
      animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi));


    var chartWidget = Padding(
      padding: EdgeInsets.all(0.5),
      child: SizedBox(
        height: 150.0,
        child: chart,
      ),
    );

    return Container(
      width: 400,
     // color: Colors.grey[400],
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new  Text("Speed: $_spd  KM/h", style: TextStyle(color: Colors.blueGrey[700])),
            chartWidget,
          ],
        ),
      );
  }
}





class distGraph extends StatefulWidget {
  distGraph({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _distGraphState createState() => _distGraphState();
}


class _distGraphState extends State<distGraph> {
  var _dist = BoxDistance.dist;

  @override
  Widget build(BuildContext context) {
    var data = [
      LiveData('', BoxDistance.dist, Colors.pink[700]),
    ];

    var series = [
      charts.Series(
        domainFn: (LiveData clickData, _) => clickData.title,
        measureFn: (LiveData clickData, _) => clickData.input,
        colorFn: (LiveData clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(0.5),
      child: SizedBox(
        height: 75.0,
        child: chart,
      ),
    );

    return Container(
      width: 400,
      //color: Colors.grey[400],

      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new  Text("Distance: $_dist KM", style: TextStyle(color: Colors.blueGrey[700])),
            chartWidget,
          ],
        ),
      );
  }
}


class powerGraph extends StatefulWidget {

  powerGraph({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _powerGraphState createState() => _powerGraphState();
}


class _powerGraphState extends State<powerGraph> {
  var _pwr = BoxPower.pwr;

  @override
  Widget build(BuildContext context) {
    var data = [
      new PowerData(1, BoxPower.pwr/4,Colors.teal[400]),
      new PowerData(2, BoxPower.pwr/2,Colors.teal[400]),
      new PowerData(3, BoxPower.pwr,Colors.teal[400]),
    ];

    var series = [
      charts.Series(
        domainFn: (PowerData clickData, _) => clickData.time,
        measureFn: (PowerData clickData, _) => clickData.watt,
        colorFn: (PowerData clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.LineChart(
      series,
      animate: true,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(0.5),
      child: SizedBox(
        height: 100.0,
        child: chart,
      ),
    );

    return Container(
      width: 400,
      //color: Colors.grey[400],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: <Widget>[
          new  Text("Power: $_pwr W", style: TextStyle(color: Colors.blueGrey[700])),

          chartWidget,
        ],
      ),
    );
  }
}





class batteryGraph extends StatefulWidget {
  batteryGraph({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _batteryGraphState createState() => _batteryGraphState();
}


class _batteryGraphState extends State<batteryGraph> {
  var  _bat = BoxBattery.bat;

  @override
  Widget build(BuildContext context) {
    var data = [
      LiveData('', BoxBattery.bat, Colors.green[500]),
    ];

    var series = [
      charts.Series(
        domainFn: (LiveData clickData, _) => clickData.title,
        measureFn: (LiveData clickData, _) => clickData.input,
        colorFn: (LiveData clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(0.5),
      child: SizedBox(
        height: 75.0,
        child: chart,
      ),
    );

    return Container(
      width: 400,
      //color: Colors.grey[400],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new  Text("Battery: $_bat %", style: TextStyle(color: Colors.blueGrey[700])),
          chartWidget,
        ],
      ),
    );
  }
}



class tempGraph extends StatefulWidget {
  tempGraph({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _tempGraphState createState() => _tempGraphState();
}


class _tempGraphState extends State<tempGraph> {
  var _temp =   BoxTemp.temp;

  @override
  Widget build(BuildContext context) {
    var data = [
      LiveData('',  BoxTemp.temp, Colors.orange[500]),
    ];

    var series = [
      charts.Series(
        domainFn: (LiveData clickData, _) => clickData.title,
        measureFn: (LiveData clickData, _) => clickData.input,
        colorFn: (LiveData clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(0.5),
      child: SizedBox(
        height: 75.0,
        child: chart,
      ),
    );

    return Container(
      width: 400,
      //color: Colors.grey[400],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Temperature: $_temp °F", style: TextStyle(color: Colors.blueGrey[700])),
          chartWidget,
        ],
      ),
    );
  }
}