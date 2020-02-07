
import 'package:flutter/material.dart';
import 'package:tictactoe_vicenzotto/data.dart';
import 'package:tictactoe_vicenzotto/utility.dart';
import 'package:tictactoe_vicenzotto/ai.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  static const AssetImage cross = AssetImage('assets/images/cross.png');
  static const AssetImage circle = AssetImage('assets/images/circle.png');
  static const AssetImage edit = AssetImage('assets/images/edit.png');



  //inizializzazione tabellone di gioco
  @override
  void initState() {
    super.initState();
    setState(() {
      data.gameBoard = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ];
    });
  }

  AssetImage getImage(int value) {
    final List<int> myCords = utility.convertToCords(value);

    switch (data.gameBoard[myCords[0]][myCords[1]]) {
      case 0:
        return edit;
        break;
      case 1:
        return cross;
        break;
      case -1:
        return circle;
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(   //barra superiore
        title: Text(
          'Tic Tac Toe Vicenzotto',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[    //pulsante per resettare i punteggi
          new IconButton(
            icon: Icon(Icons.refresh),
            onPressed:()
            {
                newGame();
            }
          )
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
                'Currently playing:',
                  style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              ),
          Text(
                utility.translateDiff(),
                  style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
              ),
          Expanded(
            child: GridView.builder(
              padding: myPadding(),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  ),
              itemCount: data.slotsTOT,
              itemBuilder: (BuildContext context, int i) => SizedBox(
                child: MaterialButton(
                  onPressed: () => playGame(utility.convertToCords(i), true),
                  child: Image(
                    image: getImage(i),
                  ),
                ),
                //size: MediaQuery.of(context).size,
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  writeText('Cross', data.crossWin, Colors.deepPurpleAccent),
                  writeText('Draw', data.draw, Colors.grey),
                  writeText('Circle', data.circleWin, Colors.deepPurpleAccent),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  color: Colors.black,
                  minWidth: 50.0,
                  height: 50.0,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    'Change Mode',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () => incDiff(),
                ),
                MaterialButton(
                  color: Colors.deepPurple,
                  minWidth: 50.0,
                  height: 50.0,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    'Play Again',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  onPressed: () => resetGame(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  //per gestire la compatipilità con dispositivi di dimensioni diverse 
  EdgeInsetsGeometry myPadding()
  {
      var screenSize = MediaQuery.of(context).size;
      print(screenSize.toString());
      if(screenSize.height < 640)
        return EdgeInsets.fromLTRB(70.0,0.0,70.0,0.0);
      else if(screenSize.height < 690)
        return EdgeInsets.fromLTRB(40.0,0.0,40.0,0.0);
      else if(screenSize.height < 750)
        return EdgeInsets.fromLTRB(25.0,0.0,25.0,0.0);
      else return EdgeInsets.all(16.0);
  }


  Widget writeText(String t, int s, Color c) {
    return Column(
      children: <Widget>[
        Text(
          t,
          style:
              TextStyle(fontSize: 30.0, color: c, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 7.0),
        Text(
          '$s',
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        )
      ],
    );
  }


  void playGame(List<int> myCords, bool human) {

    if (!data.gameEnd) {
      if (data.gameBoard[myCords[0]][myCords[1]] == 0)
        setState(() {
          data.gameBoard = utility.insertInBoard(data.gameBoard, myCords, data.isCross);
          utility.checkWin(data.gameBoard);
          if (data.gameEnd == true) {
            setState(() {
              showWinner(ai.checkScore(data.gameBoard));
              markPoints(ai.checkScore(data.gameBoard));
            });
          } else {
            //switch player
            data.isCross = data.isCross * (-1); 
            if(human)
            {
              switch (data.difficulty) {
                case 0:
                  break;
                case 1:
                  playGame(ai.worstMove(data.gameBoard), false);
                  break;
                case 2:
                  playGame(ai.randomMove(data.gameBoard), false);
                  break;
                case 3:
                  playGame(ai.bestMove(data.gameBoard), false);
                  break;
                default:
              }
            }
          }
        });
    }
  }

  //pulisce la board
  void resetGame() {
    setState(() {
      data.gameBoard = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
      ];
      data.gameEnd = false;
      data.isCross = 1;
    });
  }

  //pulisce la board
  void newGame() {
    resetGame();
    setState(() {
      data.crossWin = 0;
      data.circleWin = 0;
      data.draw = 0;
    });
  }

  //cambia difficoltà e pulisce la board
  void incDiff()
  {
    resetGame();
    setState(() {
      data.difficulty = (data.difficulty + 1) % 4;
    });
  } 

  //assegna i punti
  void markPoints(int mark) {
    switch (mark) {
      case 1:
        setState(() {
          data.crossWin += 1;
        });
        break;
      case -1:
        setState(() {
          data.circleWin += 1;
        });
        break;
      case 0:
        setState(() {
          data.draw += 1;
        });
        break;
      default:
        setState(() {
          data.draw += 1;
        });
        break;
    }
  }

  //mostra lo snackbar con il vincitore
  void showWinner(int winner) {
    String _text;

    switch (winner) {
      case -1:
        _text = 'Cerchio Vince';
        break;
      case 1:
        _text = 'Croce Vince';
        break;
      case 0:
        _text = 'Pareggio';
        break;
      default:
        _text = '??????';
        break;
    }
    _scafoldKey.currentState.showSnackBar(SnackBar(
      content: Text(_text),
      duration: const Duration(seconds: 3),
    ));
  }
}