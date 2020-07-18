import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:lean_flutter_app/speedometer/speedometer.dart';
import 'package:rxdart/rxdart.dart';

class speedometerWidget extends StatefulWidget {
  @override
  _speedometerWidgetState createState() => _speedometerWidgetState();
}
class _speedometerWidgetState extends State<speedometerWidget> {
  double _lowerValueSpeed = 1;
  double _upperValueSpeed = 2;
  int startSpeed = 0;
  int endSpeed = 4;

  PublishSubject<double> eventObservableSpeed = new PublishSubject();
  final ThemeData somTheme = new ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.black,
      backgroundColor: Colors.grey);

  @override
  Widget build(BuildContext context) {
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.startLocationService();
        // Start location service here or do something else
      },
      onDenied: () {
        // Show a message asking the user to reconsider or do something else
      },
    );
    BackgroundLocation.getLocationUpdates((location) async {
      await setState(() {
        eventObservableSpeed.add(location.speed * (18 / 5));
      });
    });
    return

      Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body: Column(
          children: [

            Container(
              height: 300,
              width: 300,
              child: Padding(
                padding: new EdgeInsets.all(40.0),
                child: new SpeedOMeter(
                    start: startSpeed,
                    end: endSpeed,
                    highlightStart: (_lowerValueSpeed / endSpeed),
                    highlightEnd: (_upperValueSpeed / endSpeed),
                    themeData: somTheme,
                    eventObservable: this.eventObservableSpeed),
              ),
            ),
          ],
        ),
      );

  }

  @override
  void dispose() {
    super.dispose();

    BackgroundLocation.stopLocationService();
  }

  @override
  void initState() {
    super.initState();


  }
}
