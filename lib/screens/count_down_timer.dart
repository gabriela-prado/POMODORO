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
  int time = 25;
  String text = "POMODORO";
  int countPomodoro = 1;
  int countDescanso = 1;
  int count = 1;
  int seguidos = 0;
  bool dialog = false;
  String labelText = "PLAY";
  IconData icon = Icons.play_arrow;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(minutes: time),
      vsync: this,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          labelText = "PAUSE";
          icon = Icons.pause;
        });

        dialog = false;
        FlutterBeep.playSysSound(49);
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          if (text == "POMODORO") {
            // incrementando pomodoros e mudando texto
            countPomodoro++;
            seguidos++;
            count = countPomodoro;
            if (seguidos % 4 == 0) {
              verificarQtdePom();
            }
          } else if (text == "DESCANSO") {
            // incrementando descanso e mudando texto
            text = "POMODORO";
            count = countPomodoro;
            controller.duration = Duration(minutes: time);
            countDescanso++;
          }

          labelText = "PLAY";
          icon = Icons.play_arrow;
        });
        FlutterBeep.playSysSound(49);
      }
    });
  }

  void descanso() {
    int descanso = 5;

    if (dialog && seguidos % 4 == 0) {
      descanso = 10;
    }

    setState(() {
      text = "DESCANSO";
      count = countDescanso;
      controller.duration = Duration(minutes: descanso);
    });
  }

  void verificarQtdePom() {
    dialog = true;
    _showMyDialog().then(
      (value) => {
        if (value == true)
          {
            setState(() {
              text = "DESCANSO";
              count = countDescanso;
              controller.duration = Duration(minutes: 10);
            }),
          }
      },
    );
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
                                      "$text $count",
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
                            setState(() {
                              if (labelText == "PLAY") {
                                labelText = "PAUSE";
                                icon = Icons.pause;
                              } else {
                                labelText = "PLAY";
                                icon = Icons.play_arrow;
                              }
                            });

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
                            icon,
                          ),
                          label: Text(
                            labelText,
                          ),
                        );
                      },
                    ),
                    Button(
                      text: "Descanso".toUpperCase(),
                      icon: Icons.night_shelter,
                      width: 150,
                      height: 50,
                      onPress: () {
                        descanso();
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
                    ),
                    Button(
                      icon: Icons.access_alarm_outlined,
                      width: 190,
                      height: 50,
                      text: "ALTERAR O TIMER",
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
        controller.duration = Duration(minutes: time);
      }),
    );
  }
}
