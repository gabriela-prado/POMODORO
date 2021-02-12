import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:pomodoro/components/button.dart';
import 'package:pomodoro/components/custom_timer_painter.dart';
import 'package:pomodoro/screens/picker_timer.dart';

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  int time = 10;
  String text = "POMODORO";
  int i = 1;
  int vezesPomodoro = 0;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: time),
      vsync: this,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        pomodoro();
      } else if (status == AnimationStatus.dismissed) {
        // a animação terminou
        descanso();
        verificarQtdePom();
      }
    });
  }

  void verificarQtdePom() {
    if (vezesPomodoro == 4) {
      _showMyDialog().then(
        (value) => {
          if (value == true){
              setState(() {
                  controller.duration = Duration(seconds: 20);
              }),
              controller.forward(),
            }
          else{
            controller.forward(),
          }
        },
      );
    } else {
      controller.forward(from: 0);
    }
  }

  void descanso() {
    setState(() {
      text = "DESCANSO";
      vezesPomodoro++;
      FlutterBeep.playSysSound(49);
      controller.duration = Duration(seconds: 5);
    });
  }

  void pomodoro() {
    FlutterBeep.playSysSound(49);
    if (text != "POMODORO") {
      text = "POMODORO";
      i++;
      FlutterBeep.playSysSound(49);

      controller.duration = Duration(seconds: time);
    }
    controller.reverse();
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('VOCÊ JÁ FEZ 4 POMODOROS SEGUIDOS!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('O que acha de descansar por 10min agora?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Não quero'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Quero!'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.indigo[900],
                  height: controller.value * MediaQuery.of(context).size.height,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(
                                    painter: CustomTimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: themeData.indicatorColor,
                                )),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "$text $i",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    Text(
                                      timerString,
                                      style: TextStyle(
                                          fontSize: 112.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return FloatingActionButton.extended(
                          onPressed: () {
                            if (controller.isAnimating)
                              controller.stop();
                            else {
                              controller.reverse(
                                from: controller.value == 0.0
                                    ? 1.0
                                    : controller.value,
                              );
                            }
                          },
                          icon: Icon(
                            controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            controller.isAnimating ? "PAUSE" : "PLAY",
                          ),
                        );
                      },
                    ),
                    Button(
                      onPress: () {
                        alterarTimer(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void alterarTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PickerTimer()),
    ).then(
      (value) => setState(() {
        debugPrint(value.toString());
        time = value;
        controller.duration = Duration(seconds: time);
      }),
    );
  }
}