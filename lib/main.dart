import 'dart:developer';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:system_clock/system_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Time Riddle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  int _counter = 0;
  bool _clockIn = false;
  AppLifecycleState notification =   AppLifecycleState.inactive;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     notification = state;
  //   });
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       {
  //         log("app in resumed");
  //         break;
  //       }
  //     case AppLifecycleState.inactive:
  //       {
  //         log("app in inactive");
  //         // saveTime();
  //         break;
  //       }
  //     case AppLifecycleState.paused:
  //       {
  //         log("app in paused");
  //         // saveTime();
  //         break;
  //       }
  //     case AppLifecycleState.detached:
  //       {
  //         log("app in detached");
  //         // saveTime();
  //         break;
  //       }
  //   }
  // }

  void _incrementCounter() async{

    // Duration since boot, not counting time spent in deep sleep.
    //log("system uptime: ${SystemClock.uptime()}");
    // final elapsedTimeDuration = _elapsedSavedTime.
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _clockIn = !_clockIn;
    });
    // Duration since boot, including time spent in sleep.

    if(_clockIn){
      saveTime();
    }else{
      log("system local time: ${DateTime.now()}");
      log("system elapsed time: ${SystemClock.elapsedRealtime()}");
      final _localSavedTime = await getLocalTime();
      final _elapsedSavedTime = await getElapsedTime();
      log('Saved Local Time: $_localSavedTime');
      log('Saved Elapsed Time: $_elapsedSavedTime');
      final _deviceRebooted = SystemClock.elapsedRealtime().compareTo(_elapsedSavedTime);
      final localTimeDifference = DateTime.now().difference(_localSavedTime);
      Duration elapsedTimeDifference = DateTime.now().subtract(_elapsedSavedTime).difference(DateTime.now().subtract(SystemClock.elapsedRealtime()));
      // elapsedTimeDifference = elapsedTimeDifference.isNegative ? elapsedTimeDifference.abs() : elapsedTimeDifference;
      log('local Time Difference : $localTimeDifference' );
      log('Elapsed Time Difference : $elapsedTimeDifference' );
      if( elapsedTimeDifference.inHours == localTimeDifference.inHours && elapsedTimeDifference.inMinutes == localTimeDifference.inMinutes){
        showFlash(
            context: context,
            duration: const Duration(seconds: 2),
            builder: (BuildContext context, controller){
              return Flash.bar(
                controller: controller,
                backgroundGradient: const LinearGradient(
                  colors: [
                    Colors.yellow, Colors.amber
                  ],
                ),
                // Position is only available for the "bar" named constructor and can be bottom/top.
                position: FlashPosition.bottom,
                // Allow dismissal by dragging down.
                enableVerticalDrag: true,
                // Allow dismissal by dragging to the side (and specify direction).
                horizontalDismissDirection:
                HorizontalDismissDirection.startToEnd,
                margin: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                // Make the animation lively by experimenting with different curves.
                forwardAnimationCurve: Curves.easeOutBack,
                reverseAnimationCurve: Curves.slowMiddle,
                // While it's possible to use any widget you like as the child,
                // the FlashBar widget looks good without any effort on your side.
                child: FlashBar(
                  title: Text(
                    'Job Completed',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  content: const Text('No Issue regarding Time Manipulation'),
                  primaryAction: IconButton(
                    // This icon's color is by default re-themed to have the primary color
                    // from the material theme - blue by default.
                    icon: const Icon(Icons.ac_unit),
                    onPressed: () {},
                  ),
                  icon: const Icon(
                    Icons.info,
                    // This color is also pulled from the theme. Let's change it to black.
                    color: Colors.black,
                  ),
                  shouldIconPulse: false,
                  showProgressIndicator: true,
                ),
              );
            });
      }else{
        showFlash(
            context: context,
            duration: const Duration(seconds: 2),
            builder: (BuildContext context, controller){
              return Flash.bar(
                controller: controller,
                backgroundGradient: const LinearGradient(
                  colors: [Colors.red, Colors.amber],
                ),
                // Position is only available for the "bar" named constructor and can be bottom/top.
                position: FlashPosition.bottom,
                // Allow dismissal by dragging down.
                enableVerticalDrag: true,
                // Allow dismissal by dragging to the side (and specify direction).
                horizontalDismissDirection:
                HorizontalDismissDirection.startToEnd,
                margin: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                // Make the animation lively by experimenting with different curves.
                forwardAnimationCurve: Curves.easeOutBack,
                reverseAnimationCurve: Curves.slowMiddle,
                // While it's possible to use any widget you like as the child,
                // the FlashBar widget looks good without any effort on your side.
                child: FlashBar(
                  title: Text(
                    'Warning',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  content: _deviceRebooted.isNegative ? const Text('Device Rebooted') : const Text('Device Time Changed'),
                  primaryAction: IconButton(
                    // This icon's color is by default re-themed to have the primary color
                    // from the material theme - blue by default.
                    icon: const Icon(Icons.ac_unit),
                    onPressed: () {},
                  ),
                  icon: const Icon(
                    Icons.info,
                    // This color is also pulled from the theme. Let's change it to black.
                    color: Colors.black,
                  ),
                  shouldIconPulse: false,
                  showProgressIndicator: true,
                ),
              );
            });
      }
    }
  }
  DateTime parseDurationToDateTime(Duration duration){
    double days = (duration.inHours - DateTime.now().hour)/24;
    int currentDayHours = duration.inHours - DateTime.now().hour;
    return DateTime(2021, 1, days.toInt(), duration.inMinutes, duration.inSeconds );
  }
  void saveTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceElapsedTime', SystemClock.elapsedRealtime().toString() );
    await prefs.setString('deviceLocalTime', DateTime.now().toString());
    await prefs.setBool('clockIn', _clockIn);

    log('Time Saved');
  }

  Future<bool> getJobStatus()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _status = prefs.getBool('clockIn') ?? false;
    setState(() {
      _clockIn = _status;
    });
    log('this is saved job Status: $_status');
    return _status;
  }

  Future<Duration> getElapsedTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final duration = prefs.getString('deviceElapsedTime') ?? '0:00:00.000000';
    //log('this is saved elapsed time: ' + duration);
    final _result = parseDuration(duration);
    return _result;
  }

  Future<DateTime> getLocalTime()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final duration = prefs.getString('deviceLocalTime') ?? '0:00:00.000000';
    //log('this is saved local time: ' + duration);
    final _result = DateTime.parse(duration);
    return _result;
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getJobStatus();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title, style: TextStyle(
          color: _clockIn ? Colors.red : Colors.white,
        ),),),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            Text(
              // '$_counter',
              _clockIn ? 'Clocked-In' : 'Clocked-Out',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                color: _clockIn ? Colors.red : Colors.black45,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: _clockIn ? const Icon(Icons.timer_off_rounded, color: Colors.red, size: 30,) : const Icon(Icons.timer, size: 30,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
