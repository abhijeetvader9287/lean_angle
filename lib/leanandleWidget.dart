import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lean_flutter_app/leananglemeter/anglemeter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';
class leanangleWidget extends StatefulWidget {
  @override
  _leanangleWidgetState createState() => _leanangleWidgetState();
}

class _leanangleWidgetState extends State<leanangleWidget> {
  double _lowerValue = 1.5;
  double _upperValue = 10.5;
  int start = 0;
  int end = 12;
  PublishSubject<double> eventObservable = new PublishSubject();
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];
  final ThemeData somTheme = new ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.black,
      backgroundColor: Colors.grey
  );

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) async{
      await  setState(() {

        _accelerometerValues = <double>[event.x, event.y, event.z];
        if(6+event.y>=0) {
          eventObservable.add(6 + event.y);
        }
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));

    return Container(
      height: 300,
      width: 300,
      child: Padding(
        padding: new EdgeInsets.all(40.0),
        child: new LeanAngleMeter(start:start, end:end, highlightStart:(_lowerValue/end), highlightEnd:(_upperValue/end), themeData:somTheme, eventObservable: this.eventObservable),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();


    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

  }
}
