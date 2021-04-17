import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:latlong/latlong.dart';

import 'package:bike_fitness/widgets/map_elevation.dart';

//List declarations
List<String> data2Double = [];
List<LatLng>  sensData2 = [];
List<ElevationPoint>elevData = [];
List<ElevationPoint>velData = [];

var lat_compare = 00.000000;
var long_compare = 00.000000;
double totalDistanceInM = 0;

//double totalDistanceInKm = totalDistanceInM*0.000621371;

// need function to stream parsed(lat, lng) into sensData

void reset(dynamic list){ // resets values stored , takes in parsed[]
   data2Double = [];
   sensData2 = [];
   elevData = [];
   velData = [];
   totalDistanceInM = 0;

   list=[];
}


 void distCalc() {  // calculates distance from point to point and adds to totalDistanceinM
  final Distance distance = Distance();
  for(var i = 0; i < sensData2.length - 1; i++){
    totalDistanceInM += distance( LatLng(sensData2[i].latitude, sensData2[i].longitude), LatLng(sensData2[i+1].latitude, sensData2[i+1].longitude)); // meters calculation, ezpz
    //totalDistanceInKm += distance.as(LengthUnit.Mile, LatLng(sensData[i].latitude, sensData[i].longitude), LatLng(sensData[i+1].latitude, sensData[i+1].longitude)); // kilometers calculation, returning 0 for some reason
    //
  }
 }


