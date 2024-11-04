import 'dart:ffi';
import 'dart:io';

import 'package:new_game/flappy/barrier.dart';
import 'package:new_game/flappy/bird.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage2 extends StatefulWidget {
  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double intialHeight = birdYaxis;
  bool gamehasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  int score=0;
  static const barrierWidth = 0.2;
  Timer? gameTimer;

  void jump() {
    setState(() {
      time = 0;
      intialHeight = birdYaxis;
    });
  }

  void startGame() {
    gamehasStarted = true;
    score = 0;
    barrierXone = 1;
    barrierXtwo = barrierXone + 1.75;
    gameTimer?.cancel(); // Cancel any existing timer
    gameTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = intialHeight - height;
      });
      setState(() {
        //moving barrier
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++;
        } else {
          barrierXone -= 0.05;
        }
      });
      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++;
        } else {
          barrierXtwo -= 0.05;
        }
        // check for collisions
        if(checkCollision()){
          timer.cancel();
          gamehasStarted=false;
          showGameOverDialog();
        }
        //bird fall below screen
        if(birdYaxis>1){
          timer.cancel();
          gamehasStarted=false;
          showGameOverDialog();
        }
      });
    });
  }
  void resetGame() {
    setState(() {
      score = 0;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      birdYaxis = 0;
      time = 0;
      height = 0;
      intialHeight = birdYaxis;
      gamehasStarted = false; // Ensure the game is stopped
      gameTimer?.cancel(); // Cancel any existing timer
    });
  }

  //collision
  bool checkCollision() {
    double gapHeight = 0.5;
    // Check collision with the first barrier
    if (barrierXone < 0.2 && barrierXone > -0.2) {
      if (birdYaxis < -gapHeight || birdYaxis > gapHeight) {
        return true;
      }
    }

    // Check collision with the second barrier
    if (barrierXtwo < 0.2 && barrierXtwo > -0.2) {
      if (birdYaxis < -gapHeight || birdYaxis > gapHeight) {
        return true;
      }
    }
    return false;
  }
  void showGameOverDialog() {  // New method to show game over dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text('Your score is $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();  // Call to reset the game
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gamehasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gamehasStarted
                        ? Text("")
                        : Text(" TAP TO PLAY ",
                        style:
                        TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Mybarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Mybarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Mybarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Mybarrier(
                      size: 250.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$score",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
