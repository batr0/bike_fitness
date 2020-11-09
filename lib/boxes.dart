import 'package:flutter/material.dart';

class BoxSpeed extends StatefulWidget {
  static double spd = 0;

  @override
  _BoxSpeedState createState() =>   _BoxSpeedState();
}
class _BoxSpeedState extends State<BoxSpeed> {
  var _spd = BoxSpeed.spd;
  @override
  Widget build(BuildContext context) {

    return Container(
        width: 300,
        height: 100,
        color: Colors.blueGrey[800],
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new  Text("Speed: $_spd KM/h", style: TextStyle(color: Colors.white)),
            new FloatingActionButton(
                   child: Icon(Icons.arrow_downward),
                 onPressed: (){
                 setState(() {
                   BoxSpeed.spd--;
                   if ( BoxSpeed.spd <0)
                     BoxSpeed.spd=0;
                   _spd--;
                   if ( _spd <0)
                     _spd=0;
                });
               }
              ),



            new FloatingActionButton(
                child:  Icon(Icons.arrow_upward),
                onPressed: (){
                setState(() {
                  BoxSpeed.spd++;
                  if ( BoxSpeed.spd <0)
                    BoxSpeed.spd=0;
                  _spd++;
                  if ( _spd >100)
                    _spd=100;
                });
                }
              ),
          ],
        )
    );
  }
}

class BoxDistance extends StatefulWidget {
static double dist = 0;
  @override
  _BoxDistanceState createState() =>   _BoxDistanceState();
}
class _BoxDistanceState extends State<BoxDistance> {
  var _dist = BoxDistance.dist;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 100,
        color: Colors.blueGrey[800],
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new  Text("Distance: $_dist KM", style: TextStyle(color: Colors.white)),
            new FloatingActionButton(
                child: Icon(Icons.arrow_downward),
                onPressed: (){
                  setState(() {

                    BoxDistance.dist--;
                    if (BoxDistance.dist <0)
                      BoxDistance.dist=0;
                    _dist--;// distance starts 0 goes on for long time
                    if ( _dist <0)
                      _dist=0;
                  });
                }
            ),



            new FloatingActionButton(
                child:  Icon(Icons.arrow_upward),
                onPressed: (){
                  setState(() {
                    _dist++;
                    BoxDistance.dist++;
                  });
                }
            ),
          ],
        )
    );
  }
}


class BoxPower extends StatefulWidget {
 static double pwr = 0;
  @override
  _BoxPowerState createState() =>   _BoxPowerState();
}
class _BoxPowerState extends State<BoxPower> {

var _pwr = BoxPower.pwr;

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 300,
        height: 100,
        color: Colors.blueGrey[800],
        child: new Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            new  Text("Power: $_pwr W", style: TextStyle(color: Colors.white)),


            new FloatingActionButton(
                child: Icon(Icons.arrow_downward),
                onPressed: (){
                  setState(() {
                    BoxPower.pwr--;
                    if (BoxPower.pwr <0)
                      BoxPower.pwr=0; // power range bottom 0
                    _pwr--;
                    if (_pwr <0)
                      _pwr=0;
                  });
                }
            ),



            new FloatingActionButton(
                child:  Icon(Icons.arrow_upward),
                onPressed: (){
                  setState(() {
                    BoxPower.pwr++;
                    _pwr++;
                  });
                }
            ),
          ],
        )
    );
  }
}



class BoxBattery extends StatefulWidget {
  static  double bat = 0;
  @override
  _BoxBatteryState createState() =>   _BoxBatteryState();
}
class _BoxBatteryState extends State<BoxBattery> {
var  _bat = BoxBattery.bat;

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 300,
        height: 100,
        color: Colors.blueGrey[800],
        child: new Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            new  Text("Battery: $_bat %", style: TextStyle(color: Colors.white)),


            new FloatingActionButton(
                child: Icon(Icons.arrow_downward),
                onPressed: (){
                  setState(() {
                    BoxBattery.bat--;
                    if (BoxBattery.bat <0)
                      BoxBattery.bat=0;
                    _bat--;
                    if (_bat <0)
                      _bat=0;

                  });
                }
            ),

            new FloatingActionButton(
                child:  Icon(Icons.arrow_upward),
                onPressed: (){
                  setState(() {
                    BoxBattery.bat++;
                    if (BoxBattery.bat >100) // range from 0-100 battery
                      BoxBattery.bat=100;
                    _bat++;
                    if(_bat>100)
                      _bat=100;
                  });
                }
            ),
          ],
        )
    );
  }
}


class BoxTemp extends StatefulWidget {
static double temp = 0;
  @override
  _BoxTempState createState() =>  _BoxTempState();
}
class _BoxTempState extends State<BoxTemp> {
var _temp =   BoxTemp.temp;
  @override
  Widget build(BuildContext context) {

    return Container(
        width: 300,
        height: 100,
        color: Colors.blueGrey[800],
        child: new Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            new  Text("Temperature: $_temp °F", style: TextStyle(color: Colors.white)),
            new FloatingActionButton(
                child: Icon(Icons.arrow_downward),
                onPressed: (){
                  setState(() {
                    BoxTemp.temp--;
                    _temp--;
                  });
                }
            ),



            new FloatingActionButton(
                child:  Icon(Icons.arrow_upward),
                onPressed: (){
                  setState(() {
                    BoxTemp.temp++;
                    _temp++; // temp can be negative and positive
                  });
                }
            ),
          ],
        )
    );
  }
}
