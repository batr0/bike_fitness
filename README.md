# Bike Fitness App

Group 47 Bike Computer Application

## Getting Started


This is the Support Page for the bike_fitness app, currently under construction!

Below is a how-to on using the app in its current state (11/17/20)

This app uses:
- [map_elevation](https://github.com/OwnWeb/map_elevation)
- [flutter_map](https://pub.dev/packages/flutter_map)
- [flutter_blue](https://github.com/pauldemarco/flutter_blue)

### Bluetooth Setup
First tab is Settings, click on the triple dashes, and then click the Bluetooth page

On the bottom right press the search button to find your devices (Must have BT and Location turned on)

Devices should pop up with an indication of connectivity strength, and a connect button

Hit connect, and the device characteristc page should pop up

Click on the service you want, then the characteristic underneath it, and press download to view the data, refresh to upload (0x2A19 for Battery Level)


### Inputs
Speed

Power

Battery

Distance

Temperature


### Live Display
Displays inputs, and Live battery level of BT device

### Maps
Home: Openstreetmaps default, centered on College Station

Polyline: Routing data with Google map coordinates, and live tests

Z-Data: swipable histogram that displays Z-data (speed, power, distance, etc...) compared to X, Y (Latitude/Longitude)




