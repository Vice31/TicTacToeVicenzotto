import 'package:tictactoe_vicenzotto/data.dart';


class utility{

  static List<int> convertToCords(int index) {
    //converte l'indice in una posizione nella matrice
    final List<int> myTempCords = [0, 0];

    myTempCords[0] = index~/data.side;
    myTempCords[1] = index%data.side;

    return myTempCords;
  }

  static List<List<int>> insertInBoard(List<List<int>> boardCopy, List<int> myTempCords, int pValue) {
    boardCopy[myTempCords[0]][myTempCords[1]] = pValue; //inserisco il valore sulla board
    boardCopy[myTempCords[0]][3] += pValue; //win righe
    boardCopy[3][myTempCords[1]] += pValue; //win colonne
    if (myTempCords[0] == myTempCords[1]) boardCopy[3][3] += pValue; //diagonale
    return boardCopy;
  }

  static String translateDiff() {

    String temp = 'null';

    switch (data.difficulty) {
      case 0:
        temp = '2 players mode';
        break;
      case 1:
        temp = 'easy mode';
        break;
      case 2:
        temp = 'medium mode';
        break;
      case 3:
        temp = 'impossible mode';
        break;
      default:
        temp = '????';
        break;
    }
    return temp;
  }

  static void checkWin(List<List<int>> myBoard) {
    bool tie = true;
    for (int i = 0; i < data.side; i++) {
      for (int j = 0; j < data.side; j++) {
        if (myBoard[i][j] == 0) tie = false;
      }
    }

    if (myBoard[0][3].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[1][3].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[2][3].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[3][0].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[3][1].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[3][2].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[3][3].abs() > 2) {
      data.gameEnd = true;
    } else if (myBoard[0][2] == myBoard[1][1] &&
        myBoard[1][1] == myBoard[2][0] &&
        myBoard[1][1] != 0) {
      data.gameEnd = true;
    } else if (tie == true) {
      data.gameEnd = true;
    }
  }

}



  