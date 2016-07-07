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
    
    func opposite() -> CellType {
        if self == .X {
            return .O
        } else if self == .O {
            return .X
        } else {
            return .Empty
        }
    }
    
}

enum OXGameState : String {
    case InProgress
    case Tie
    case Won
    case Open = "Open"
    case Abandoned = "Abandoned"
}

class OXGame {
    
    var ID: Int
    var host: String
    
    var board = [CellType](count: 9, repeatedValue: CellType.Empty)
    var startType: CellType = CellType.X
    
    init()  {
        
        self.ID = 0
        self.host = ""
        
    }
    
    // Methods
    
    func deserialiseBoard(boardString: String) {
        
        var tempArray = [CellType]()
        
        for char in boardString.characters {
            switch char {
            case "x":
                tempArray.append(CellType.X)
            case "o":
                tempArray.append(CellType.O)
            default:
                tempArray.append(CellType.Empty)
            }
        }
        
        // updates board
        board = tempArray
        
    }
    
    func serialiseBoard() -> String {
        
        var tempString = ""
        
        for cell in board {
            switch cell {
            case CellType.X:
                tempString = tempString + "x"
            case CellType.O:
                tempString = tempString + "o"
            default:
                tempString = tempString + "_"
            }
        }
        
        return tempString
        
    }
    
    func turnCount() -> Int {
        
        var count: Int = 0
        
        for cell in board {
            if cell != CellType.Empty {
                count += 1
            }
        }
        
        return count
    }
    
    func whoseTurn() -> CellType {
        if turnCount() % 2 == 0 {
            return startType
        } else {
            return startType.opposite()
        }
    }
    
    // Does multiple things:
    // checks whether cell is empty, updates turns, etc
    func playMove(cellNumber: Int) -> CellType {
        /*
        if board[cellNumber] != CellType.Empty {
            return board[cellNumber]
        }
         */
        
        board[cellNumber] = whoseTurn()
        return board[cellNumber]
    }
    
    func gameWon() -> Bool {
        // first row
        if ((board[0], board[1]) == (board[1], board[2])) && ((board[0] == CellType.O) || (board[0] == CellType.X)) {
            print("row 1")
            return true
        }
        // second row
        else if ((board[3], board[4]) == (board[4], board[5])) && ((board[3] == CellType.O) || (board[3] == CellType.X)) {
            print("row 2")
            return true
        }
        // third row
        else if ((board[6], board[7]) == (board[7], board[8])) && ((board[6] == CellType.O) || (board[6] == CellType.X)) {
            print("row 3")
            return true
        }
        // first column
        else if ((board[0], board[3]) == (board[3], board[6])) && ((board[0] == CellType.O) || (board[0] == CellType.X)) {
            print("column 1")
            return true
        }
        // second column
        else if ((board[1], board[4]) == (board[4], board[7])) && ((board[1] == CellType.O) || (board[1] == CellType.X)) {
            print("column 2")
            return true
        }
        // third column
        else if ((board[2], board[5]) == (board[5], board[8])) && ((board[2] == CellType.O) || (board[2] == CellType.X)) {
            print("column 3")
            return true
        }
        // right bottom diagonal
        else if ((board[0],board[4]) == (board[4], board[8])) && ((board[0] == CellType.O) || (board[0] == CellType.X)) {
            print("right bottom diagonal")
            return true
        }
        // right top diagonal
        else if ((board[6], board[4]) == (board[4], board[2])) && ((board[6] == CellType.O) || (board[6] == CellType.X)) {
            print("right top diagonal")
            return true
        }
        return false
    }
    
    func state() -> OXGameState {
        if gameWon() {
            return OXGameState.Won
        }
        else if !gameWon() && turnCount() == 9 {
            return OXGameState.Tie
        }
        else {
            return OXGameState.InProgress
        }
    }
    
    func reset() {
        for i in 0 ..< board.count {
            board[i] = .Empty
        }
    }
    
}
