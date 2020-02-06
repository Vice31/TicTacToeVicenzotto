import 'dart:math';
import 'package:tictactoe_vicenzotto/data.dart';
import 'package:tictactoe_vicenzotto/utility.dart';

class ai{

  static List<int> bestMove(List<List<int>> boardCopy) {
    //variabili di calcolo
    List<int> botTempCords;
    int tempScore;
    int player = data.isCross;

    //risultati
    int bestScore;
    List<int> bestCords; //DA INIZIALIZZARE...nah

    for (int i = 0; i < 9; i++) {
      botTempCords = utility.convertToCords(i);
      if (boardCopy[botTempCords[0]][botTempCords[1]] == 0) {
        List<List<int>> botBoard;
        botBoard = [
          [boardCopy[0][0], boardCopy[0][1], boardCopy[0][2], boardCopy[0][3]],
          [boardCopy[1][0], boardCopy[1][1], boardCopy[1][2], boardCopy[1][3]],
          [boardCopy[2][0], boardCopy[2][1], boardCopy[2][2], boardCopy[2][3]],
          [boardCopy[3][0], boardCopy[3][1], boardCopy[3][2], boardCopy[3][3]]
        ];
        botBoard = utility.insertInBoard(botBoard, botTempCords, player);
        if(checkScore(botBoard) == player)
        {return botTempCords;}
        tempScore = minimax(botBoard, false, player);
        if (bestScore == null) {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
        if (tempScore < bestScore && player == -1)
        {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
        if (tempScore > bestScore && player == 1)
        {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
      }
    }
    return bestCords;
  }

  static List<int> worstMove(List<List<int>> boardCopy) {
    //variabili di calcolo
    List<int> botTempCords;
    int tempScore;
    int player = data.isCross;

    //risultati
    int bestScore;
    List<int> bestCords; //DA INIZIALIZZARE...nah

    for (int i = 0; i < 9; i++) {
      botTempCords = utility.convertToCords(i);
      if (boardCopy[botTempCords[0]][botTempCords[1]] == 0) {
        List<List<int>> botBoard;
        botBoard = [
          [boardCopy[0][0], boardCopy[0][1], boardCopy[0][2], boardCopy[0][3]],
          [boardCopy[1][0], boardCopy[1][1], boardCopy[1][2], boardCopy[1][3]],
          [boardCopy[2][0], boardCopy[2][1], boardCopy[2][2], boardCopy[2][3]],
          [boardCopy[3][0], boardCopy[3][1], boardCopy[3][2], boardCopy[3][3]]
        ];
        botBoard = utility.insertInBoard(botBoard, botTempCords, player);
        if(checkScore(botBoard) == player)
        {tempScore = player;}
        else{tempScore = minimax(botBoard, false, player);}
        if (bestScore == null) {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
        if (tempScore > bestScore && player == -1)
        {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
        if (tempScore < bestScore && player == 1)
        {
          bestScore = tempScore;
          bestCords = botTempCords;
        }
      }
    }
    return bestCords;
  }

  static List<int> randomMove(List<List<int>> boardCopy)
  {
    List<int> randomCords;
    List<int> playPool = [];

    for (int i = 0; i < 9; i++) {
      randomCords = utility.convertToCords(i);
      if (boardCopy[randomCords[0]][randomCords[1]] == 0)
      {
        playPool.add(i);
      }
    }
    Random random = new Random();
    randomCords = utility.convertToCords(playPool.elementAt(random.nextInt(playPool.length)));

    return randomCords;
  }

  static int minimax(List<List<int>> boardCopy, bool isMaximizing, int pValue) {
    List<int> botTempCords;
    int score = checkScore(boardCopy); // 1 = player | -1 = bot | 0 = pareggio | -100 = non concluso
    int tempScore = 0;
    if (score != -100) {
      return score;
    }

    //qua ci va un bell' ELSE su tutto in teoria
    isMaximizing = !isMaximizing; //i guess
    pValue *= -1;

    for (int i = 0; i < 9; i++) {
      botTempCords = utility.convertToCords(i);
      if (boardCopy[botTempCords[0]][botTempCords[1]] == 0) {
        List<List<int>> botBoard;
        botBoard = [
          [boardCopy[0][0], boardCopy[0][1], boardCopy[0][2], boardCopy[0][3]],
          [boardCopy[1][0], boardCopy[1][1], boardCopy[1][2], boardCopy[1][3]],
          [boardCopy[2][0], boardCopy[2][1], boardCopy[2][2], boardCopy[2][3]],
          [boardCopy[3][0], boardCopy[3][1], boardCopy[3][2], boardCopy[3][3]]
        ];
        botBoard = utility.insertInBoard(botBoard, botTempCords, pValue);

        List<List<int>> changedBotBoard;
        changedBotBoard = [
          [botBoard[0][0], botBoard[0][1], botBoard[0][2], botBoard[0][3]],
          [botBoard[1][0], botBoard[1][1], botBoard[1][2], botBoard[1][3]],
          [botBoard[2][0], botBoard[2][1], botBoard[2][2], botBoard[2][3]],
          [botBoard[3][0], botBoard[3][1], botBoard[3][2], botBoard[3][3]]
        ];
        tempScore = minimax(changedBotBoard, isMaximizing, pValue);

        if (score == -100) {
          score = tempScore;
        } else {
          if (isMaximizing)
            score = max(score, tempScore);
          else
            score = min(score, tempScore);
        }
      }
    }

    return score;
  }

  static int checkScore(List<List<int>> myBoard) {
    bool tie = true;
    for (int i = 0; i < data.side; i++) {
      for (int j = 0; j < data.side; j++) {
        if (myBoard[i][j] == 0) tie = false;
      }
    }

  for(int i = 0; i<data.side; i++)
  {
    if (myBoard[i][data.side].abs() > 2) { if (myBoard[i][data.side] > 0) { return 1;} else {return -1;}}
    else if (myBoard[data.side][i].abs() > 2) { if (myBoard[data.side][i] > 0) { return 1;} else {return -1;}}
  }

  if (myBoard[data.side][data.side].abs() > 2) {if (myBoard[data.side][data.side] > 0) {return 1;} else {return -1;}}
  else if (myBoard[0][2] == 1 && myBoard[1][1] == 1 && myBoard[2][0] == 1) {return 1;}
  else if (myBoard[0][2] == -1 && myBoard[1][1] == -1 && myBoard[2][0] == -1) {return -1;}
  else if (tie == true) { return 0;} 
  else {return -100;}
  }

}