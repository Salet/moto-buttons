import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  StreamSubscription<Position> _positionStream;
  int _speed = 0;

  void _checkPermissions() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();

    _checkPermissions();

    _positionStream = Geolocator.getPositionStream(
            forceAndroidLocationManager: true,
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((position) {
      _onSpeedChange(position == null
          ? 0.0
          : (position.speed * 18) /
              5); //Converting position speed from m/s to km/hr
    });
  }

  void _onSpeedChange(double newSpeed) async {
    setState(() {
      _speed = newSpeed.toInt();
    });
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('$_speed', style: TextStyle(fontSize: 72)),
        Text('km/h', style: TextStyle(fontSize: 34)),
      ]),
    );
  }
}
