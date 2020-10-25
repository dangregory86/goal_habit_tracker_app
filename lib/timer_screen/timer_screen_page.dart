import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimerPage extends StatefulWidget {
  TimerPage({this.title}) : super(key: key);

  final String title;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  Stream<int> _timerStream;
  StreamSubscription<int> timerSubscription;

  String hoursStr = '00', minutesStr = '00', secondsStr = '00';

  Color testColor = Colors.red;
  String activity = 'Test Activity';

  bool close = false;

  void _updateUI(newTick) {
    setState(() {
      if (newTick % 2 == 0) {
        // testColor = Colors.blue;
      } else {
        // testColor = Colors.red;
      }
      hoursStr =
          ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
      secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
    });
  }

  @override
  void initState() {
    super.initState();
    _timerStream = timerStream();
    timerSubscription = _timerStream.listen((int newTick) {
      _updateUI(newTick);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timerSubscription.cancel();
    _timerStream = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // _closeTimer(context);
        Fluttertoast.showToast(
            msg: "get back to work",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.amber,
            textColor: Colors.red,
            fontSize: 24);
        break;
      case AppLifecycleState.detached:
        _closeTimer(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: testColor,
                  child: Text(
                    'Keep up the good work, you\'ve been $activity for :',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    '$hoursStr:$minutesStr:$secondsStr',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RaisedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text('Are you sure?'),
                            content: new Text('Do you really want to quit?'),
                            actions: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  close = true;
                                  Navigator.of(context).pop(true);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.white),),
                                color: Colors.blue,
                                child: Text("YES"),
                              ),
                            ],
                          ),
                        ).then((value) {
                          if(close == true){
                            Navigator.pop(context);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.white),
                      ),
                      padding: const EdgeInsets.all(5),
                      color: Colors.blue,
                      elevation: 20,
                      child: Text(
                        'STOP',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Stream used to create a timer.
  Stream<int> timerStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
    );
    return streamController.stream;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you really want to quit?'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.of(context).pop(true),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.white),),
            color: Colors.blue,
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
}

void _closeTimer(context) {
  Navigator.pop(context);
}
