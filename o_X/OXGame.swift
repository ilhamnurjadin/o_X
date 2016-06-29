//
//  OXGame.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

enum CellType : String {
    case O = "O"
    case X = "X"
    case Empty = ""
}

enum OXGameState : String {
    case InProgress
    case Tie
    case Won
}

class OXGame {
    
    var board = [CellType](count: 9, repeatedValue: CellType.Empty)
    var startType: CellType = CellType.X
    var numOfTurns = 0
    var currentTurn: CellType = CellType.X
    
    // Methods
    func turnCount() -> Int {
        print(numOfTurns)
        return numOfTurns
    }
    
    func updateTurn() {
        if currentTurn == CellType.X {
            currentTurn = CellType.O
        }
        else if currentTurn == CellType.O {
            currentTurn = CellType.X
        }
        print(currentTurn)
    }
    
    func whoseTurn() -> CellType {
        
        return currentTurn
        
        /*
        var secondPlayerType: CellType = CellType.Empty
        
        if startType == CellType.X {
            secondPlayerType = CellType.O
        }
        else if startType == CellType.O {
            secondPlayerType = CellType.X
        }
        
        switch numOfTurns {
        case 0, 2, 4, 6, 8:
            return startType
        case 1, 3, 5, 7, 9:
            return secondPlayerType
        default:
            return CellType.Empty
        }
        */
    }
    
    func checkButtonValidity(cellNumber: Int) -> Bool {
        if board[cellNumber] != CellType.Empty {
            return false
        }
        return true
    }
    
    func playMove(cellNumber: Int) -> CellType {
        board[cellNumber] = currentTurn
        print("This is now an \(currentTurn)")
        return currentTurn
    }
    
    func gameWon() -> Bool {
        // first row
        if (board[0] == board[1] && board[0] == board[2]) {
            return true
        }
        // second row
        else if (board[3] == board[4] && board[3] == board[5]) {
            return true
        }
        // third row
        else if (board[6] == board[7] && board[6] == board[8]) {
            return true
        }
        // first column
        else if (board[0] == board[3] && board[0] == board[6]) {
            return true
        }
        // second column
        else if (board[1] == board[4] && board[1] == board[7]) {
            return true
        }
        // third column
        else if (board[2] == board[5] && board[2] == board[8]) {
            return true
        }
        // right bottom diagonal
        else if (board[0] == board[4] && board[0] == board[8]) {
            return true
        }
        // right top diagonal
        else if (board[6] == board[4] && board[6] == board[2]) {
            return true
        }
        return false
    }
    
    // start here
    func state() -> OXGameState {
        if gameWon() == true {
            return OXGameState.Won
        }
        else if gameWon() == false && turnCount() >= 9 {
            return OXGameState.Tie
        }
        else {
            return OXGameState.InProgress
        }
    }
    
    func reset() {
        var i = 0
        while (i < 9) {
            board[i] = CellType.Empty
            i += 1
        }
    }
    
}
