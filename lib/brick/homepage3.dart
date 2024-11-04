import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_game/brick/ball.dart';
import 'package:new_game/brick/brick.dart';
import 'package:new_game/brick/coverscreen.dart';
import 'package:new_game/brick/gameoverscreen.dart';
import 'package:new_game/brick/player.dart';
import 'dart:async';

class HomePage3 extends StatefulWidget {
  const HomePage3({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

enum Direction { UP, DOWN, LEFT, RIGHT }

class HomePageState extends State<HomePage3> {
  double ballX = 0;
  double ballY = 0;
  double ballXIncrements = 0.01;
  double ballYIncrements = 0.01;
  var ballYDirection = Direction.DOWN;
  var ballXDirection = Direction.LEFT;

  bool hasGameStarted = false;
  bool isGameOver = false;

  double playerX = 0;
  double playerWidth = 0.4;

  static double firstbrickX = -1 + wallGap;
  static double firstbrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.2;
  static int numberofBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 - numberofBricksInRow * brickWidth - (numberofBricksInRow - 1) * brickGap);

  List<List<dynamic>> MyBricks = [
    [firstbrickX, firstbrickY, false],
    [firstbrickX + 1 * (brickWidth + brickGap), firstbrickY, false],
    [firstbrickX + 2 * (brickWidth + brickGap), firstbrickY, false]
  ];

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      updateDirection();
      moveBall();

      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      checkBrickCollision();
    });
  }

  void checkBrickCollision() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;
          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          String min =
          findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          switch (min) {
            case 'left':
              ballXDirection = Direction.LEFT;
              break;
            case 'right':
              ballXDirection = Direction.RIGHT;
              break;
            case 'up':
              ballYDirection = Direction.UP;
              break;
            case 'down':
              ballYDirection = Direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) return 'left';
    if ((currentMin - b).abs() < 0.01) return 'right';
    if ((currentMin - c).abs() < 0.01) return 'up';
    if ((currentMin - d).abs() < 0.01) return 'down';
    return '';
  }

  bool isPlayerDead() {
    return ballY >= 1;
  }

  void moveBall() {
    setState(() {
      if (ballXDirection == Direction.LEFT) {
        ballX -= ballXIncrements;
      } else {
        ballX += ballXIncrements;
      }

      if (ballYDirection == Direction.DOWN) {
        ballY += ballYIncrements;
      } else {
        ballY -= ballYIncrements;
      }
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.UP;
      }
      if (ballY <= -1.0) ballYDirection = Direction.DOWN;
      if (ballX <= -1.0) ballXDirection = Direction.RIGHT;
      if (ballX >= 1.0) ballXDirection = Direction.LEFT;
    });
  }

  void movePlayer(double dx) {
    setState(() {
      playerX += dx;
      if (playerX < -1) playerX = -1; // Prevent player from going off the screen
      if (playerX + playerWidth > 1) playerX = 1 - playerWidth; // Prevent overflow
    });
  }

  void resetGame() {
    setState(() {
      playerX = 0;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;

      MyBricks = [
        [firstbrickX, firstbrickY, false],
        [firstbrickX + 1 * (brickWidth + brickGap), firstbrickY, false],
        [firstbrickX + 2 * (brickWidth + brickGap), firstbrickY, false]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        movePlayer(details.delta.dx / MediaQuery.of(context).size.width * 2);
      },
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Center(
          child: Stack(
            children: [
              CoverScreen(hasGameStarted: hasGameStarted),
              GameOverScreen(
                isGameOver: isGameOver,
                function: resetGame,
              ),
              MyBall(ballX, ballY,
                  isGameOver: isGameOver, hasGameStarted: hasGameStarted),
              MyPlayer(playerX: playerX, playerWidth: playerWidth),
              for (var brick in MyBricks)
                MyBricK(
                  brickX: brick[0],
                  brickY: brick[1],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                  brickBroken: brick[2],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
