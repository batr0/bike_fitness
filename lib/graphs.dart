import 'dart:async';
import 'dart:math';

import 'package:bike_fitness/dataparser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bike_fitness/boxes.dart';

import 'package:bike_fitness/widgets.dart';
import 'package:bike_fitness/btserial/example/ChatPage.dart';
import 'package:flutter/rendering.dart';


class LiveData {
  final String title;
  final double input;
  final charts.Color color;

  LiveData(this.title, this.input, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
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

class gridGraph extends StatelessWidget {


  var _spd = BoxSpeed.spd;
  var _temp =   BoxTemp.temp;
  var _bat = BoxBattery.bat;
  var _dist = BoxDistance.dist;
  var _pwr = BoxPower.pwr;


  Widget build(BuildContext context) {
    totalDistanceInM=0;

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
                       child:StreamBuilder<String>(
                         stream: speedStream(),
                         initialData: '0' ,
                         builder: ( context,  snapshot){

                                                             /*debugPrint('snapshot.data: '+snapshot.data.toString());
                                                             debugPrint('snapshot connection state: '+snapshot.connectionState.toString());
                                                             debugPrint('snapshot error: '+snapshot.hasError.toString());
                                                             debugPrint('snapshot has data: '+snapshot.hasData.toString());
                                                            // debugPrint('snapshot is pause: '+controller.isPaused.toString());
                                                             debugPrint('snapshot to string: '+ ChatPage().toString());
                                                            // debugPrint('ss paused'+ss.isPaused.toString());
                                                            // debugPrint('smegma.last:    :   '+smegma.last.toString());
                                                             //debugPrint('snapshot list :   '+smegma.last.toString());*/

                            if(!snapshot.hasData){
                              return Container(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[700])),width: 60,height: 60, padding: EdgeInsets.all(10));
                            }
                            else if(snapshot.hasError){
                             return Text("Error");
                           }
                           else {

                             return Text(snapshot.data,
                                 style: TextStyle(color: Colors.pink[700]));
                           }
                         },
                       )),
                 ),
                     Expanded(
                       child:   Text("MPH",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
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
                          child:Text(" $_pwr ",  style: TextStyle(color: Colors.lightBlue[100]))),
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
                          child:StreamBuilder<String>(
                            stream: gpsStream(),
                            initialData: '0.00' ,
                            builder: ( context,  snapshot){

                              /*debugPrint('snapshot.data: '+snapshot.data.toString());
                              debugPrint('snapshot connection state: '+snapshot.connectionState.toString());
                              debugPrint('snapshot error: '+snapshot.hasError.toString());
                              debugPrint('snapshot has data: '+snapshot.hasData.toString());
                              // debugPrint('snapshot is pause: '+controller.isPaused.toString());
                              debugPrint('snapshot to string: '+ ChatPage().toString());
                              // debugPrint('ss paused'+ss.isPaused.toString());
                              // debugPrint('smegma.last:    :   '+smegma.last.toString());
                              //debugPrint('snapshot list :   '+smegma.last.toString());*/

                              if(!snapshot.hasData){
                                return Container(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green[700])),width: 60,height: 60, padding: EdgeInsets.all(10));
                              }
                              else if(snapshot.hasError){
                                return Text("Error");
                              }
                              else {

                                return Text(snapshot.data,
                                    style: TextStyle(color: Colors.green[700]));
                              }
                            },
                          )),
                    ),
                    Expanded(
                      child:   Text("Miles",  style: TextStyle(color: Colors.blueGrey[50],fontSize: 45),),
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
                          child:StreamBuilder<String>(
                            stream: tempStream(),
                            initialData: '0' ,
                            builder: ( context,  snapshot){

                              /*debugPrint('snapshot.data: '+snapshot.data.toString());
                              debugPrint('snapshot connection state: '+snapshot.connectionState.toString());
                              debugPrint('snapshot error: '+snapshot.hasError.toString());
                              debugPrint('snapshot has data: '+snapshot.hasData.toString());
                              // debugPrint('snapshot is pause: '+controller.isPaused.toString());
                              debugPrint('snapshot to string: '+ ChatPage().toString());
                              // debugPrint('ss paused'+ss.isPaused.toString());
                              // debugPrint('smegma.last:    :   '+smegma.last.toString());
                              //debugPrint('snapshot list :   '+smegma.last.toString());*/

                              if(!snapshot.hasData){
                                return Container(child:CircularProgressIndicator(),width: 60,height: 60, padding: EdgeInsets.all(10));
                              }
                              else if(snapshot.hasError){
                                return Text("Error");
                              }
                              else {

                                return Text(snapshot.data,
                                    style: TextStyle(color: Colors.yellow[700]));
                              }
                            },
                          )),
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