# Bike Fitness App

Group 47 Bike Phone Application

## Getting Started


This is the Support Page for the bike_fitness app, currently under construction!

Below is a how-to on using the app in its current state (4/21/21)

This app uses:
- [map_elevation](https://github.com/OwnWeb/map_elevation)
- [flutter_map](https://pub.dev/packages/flutter_map)
- [flutter_bluetooth_serial](https://github.com/edufolly/flutter_bluetooth_serial)
- [csv](https://pub.dev/packages/csv)
- [file_picker](https://pub.dev/packages/file_picker)
 
### Settings and Setup

-Tap top right 3 bars settings

### Bluetooth
-Flutter Bluetooth Serial plugin, Click "Connect to paired device chat"
-Choose ESP32 as device, Live Display will load and wait for BT connection

### Rides
-After ride, generate CSV by tapping " Load created Csv"
-Will pull up current data stored for ride
-"load all csv from phone storage" will pull up all previous rides with timestamped file


### Maps
-Post ride, route will be displayed on map
-For Eleveation Layout, hit settings bar, and click "Elevation Data". This displays Eleveation data at a certain GPS lat, long
-For Velocity Layout, hit settings bar, and click "Velocity Data". This displays Velocity data at a certain GPS lat, long


### Live Display
- Speed in MPH
- Distance in Miles
- Duration HH:MM:SS
- Dynamo Watts produced
- RPM/cadence
- Internal/External Temperature
- Altitude
- Acceleration
- Satellite Connections
- Cardinal Direction







