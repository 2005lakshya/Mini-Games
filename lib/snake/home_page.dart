import 'dart:math';
import 'package:new_game/home.dart';
import 'package:new_game/snake/blank_pixel.dart';
import 'package:new_game/snake/food_pixel.dart';
import 'package:new_game/snake/snake_pixel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  //user score
  int currentScore = 0;

  //snake
  List<int> snakePos = [
    0,
    1,
    2,
  ];
  //snake direction
  var currentDirection = snake_direction.RIGHT;

  //food
  int foodPos = 55;

  //timer
  Timer? gameTimer;

  // start game
  void startGame() {
    gameTimer?.cancel();
    Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      setState(() {
        // Keep the snake moving
        moveSnake();
        // Game over check
        if (gameOver()) {
          timer.cancel();
          showGameOverDialog(); // Call to the new method
        }
      });
    });
  }

  void showGameOverDialog() {
    // New method to show game over dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text('Your score is $currentScore'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame(); // Call to reset the game
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    // New method to reset the game state
    setState(() {
      currentScore = 0;
      snakePos = [0, 1, 2];
      currentDirection = snake_direction.RIGHT;
      foodPos = 55;
    });
    startGame(); // Restart the game
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_direction.RIGHT:
        {
          //if snake at right wall
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_direction.DOWN:
        {
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  //game over
  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        //high score
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current score',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(
                    currentScore.toString(),
                    style: TextStyle(fontSize: 36, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),

        // game grid
        Expanded(
          flex: 3,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0 &&
                  currentDirection != snake_direction.UP) {
                currentDirection = snake_direction.DOWN;
              } else if (details.delta.dy < 0 &&
                  currentDirection != snake_direction.DOWN) {
                currentDirection = snake_direction.UP;
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0 &&
                  currentDirection != snake_direction.LEFT) {
                currentDirection = snake_direction.RIGHT;
              } else if (details.delta.dx < 0 &&
                  currentDirection != snake_direction.RIGHT) {
                currentDirection = snake_direction.LEFT;
              }
            },
            child: GridView.builder(
                itemCount: totalNumberOfSquares,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoodPixel();
                  } else {
                    return const BlankPixel();
                  }
                }),
          ),
        ),
        // play button
        Row(
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                      child: Text("Play"),
                      color: Colors.pink,
                      onPressed: startGame),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    child: Text("Quit"),
                    color: Colors.pink,
                    onPressed: () {
                      Navigator.pop(context); // This will pop the current screen and return to the previous one.
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
