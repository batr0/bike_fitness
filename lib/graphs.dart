import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bike_fitness/boxes.dart';
import 'package:bike_fitness/widgets.dart';






class PowerData {
  final double  time;
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


class speedGraph extends StatefulWidget {
  speedGraph({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _speedGraphState createState() => _speedGraphState();
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
        measureFn: (LiveData segment, _) => segment.input,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.PieChart(
      series,
      animate: true,

        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30, startAngle: 4 / 5 * pi, arcLength: 7 / 5 * pi),


    );


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
            //chartWidget,
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
      new PowerData(0.5*BoxPower.pwr, BoxPower.pwr/4,Colors.teal[400]),
      new PowerData(1.0*BoxPower.pwr, BoxPower.pwr/2,Colors.teal[400]),
      new PowerData(1.5*BoxPower.pwr , BoxPower.pwr,Colors.teal[400]),
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
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(50),
            charts.TickSpec<num>(100),
          ],
        ),
      ),
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
  var _bat = BoxBattery.bat;



  @override
  Widget build(BuildContext context) {
    var data = [
      LiveData('', BoxBattery.bat, Colors.transparent),
    ];

    var series = [
      charts.Series(
          id: 'Clicks',
          data: data,
        domainFn: (LiveData clickData, _) => clickData.title,
        measureFn: (LiveData clickData, _) => clickData.input,
        // ignore: missing_return
        colorFn: (LiveData clickData, _) {
            //RANGE COLOR BATTERY
            if(BoxBattery.bat<=100 && BoxBattery.bat>=75) {
              return charts.ColorUtil.fromDartColor(Colors.green[500]);
            }
            else if(BoxBattery.bat<75 && BoxBattery.bat>=50) {
              return charts.ColorUtil.fromDartColor(Colors.yellow[700]);
            }
            else if(BoxBattery.bat<50 && BoxBattery.bat>=25) {
              return charts.ColorUtil.fromDartColor(Colors.orange[500]);
            }
            else if(BoxBattery.bat<25 && BoxBattery.bat>=0) {
              return charts.ColorUtil.fromDartColor(Colors.pink[700]);
            }
        }

      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(100),
          ],
        ),
      ),
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
        //  chartWidget,
        ],
      ),
    );
  }
}



class gridGraph extends StatefulWidget {
gridGraph({Key key, this.title}) : super(key: key);
final String title;

@override
_gridGraphState createState() => _gridGraphState();
}

class _gridGraphState extends State<gridGraph> {
  var _spd = BoxSpeed.spd;
  var _temp =   BoxTemp.temp;
  var _bat = BoxBattery.bat;
  var _dist = BoxDistance.dist;
  var _pwr = BoxPower.pwr;

  Widget build(BuildContext context) {
    return  GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2 ,
        mainAxisSpacing:5,
        crossAxisSpacing: 5,
        padding: EdgeInsets.all(5),
        children:<Widget>[
          Card(
              color: Colors.blueGrey[800],
               child: Column(
               children:<Widget>[
                 Expanded(
                   flex: 2,
                   child: FittedBox(
                       alignment: Alignment.bottomCenter,
                       fit: BoxFit.contain,
                       child:Text(" $_spd ",  style: TextStyle(color: Colors.yellow[700]))),
                 ),
                     Expanded(
                       child:   Text("KM/h",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
                     ),
                 ]
               )
          ),
          Card(
              color: Colors.blueGrey[800],
              child: Column(
                  children:<Widget>[
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          child:Text(" $_pwr ",  style: TextStyle(color: Colors.yellow[700]))),
                    ),
                    Expanded(
                      child:   Text("Watts",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
                    ),
                  ]
              )
          ),
          Card(
              color: Colors.blueGrey[800],
              child: Column(
                  children:<Widget>[
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          child:Text(" $_dist ",  style: TextStyle(color: Colors.yellow[700]))),
                    ),
                    Expanded(
                      child:   Text("KM",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
                    ),
                  ]
              )
          ),
          Card(
              color: Colors.blueGrey[800],
              child: Column(
                  children:<Widget>[
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          child:Text(" $_temp ",  style: TextStyle(color: Colors.yellow[700]))),
                    ),
                    Expanded(
                      child:   Text("°F",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
                    ),
                  ]
              )
          ),
        ]
    );
  }
}