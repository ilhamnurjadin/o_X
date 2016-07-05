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
    case Open = "Open"
    case Abandoned = "Abandoned"
}

class OXGame {
    
    var ID: Int = 42
    var host: String = "my@email.sucks"
    
    var board = [CellType](count: 9, repeatedValue: CellType.Empty)
    var startType: CellType = CellType.X
    var numOfTurns = 0
    var currentTurn: CellType = CellType.X
    
    init()  {
        //we are simulating setting our board from the internet
        let simulatedBoardStringFromNetwork = "_________" //update this string to different values to test your model serialisation
        self.board = deserialiseBoard(simulatedBoardStringFromNetwork) //your OXGame board model should get set here
        if(simulatedBoardStringFromNetwork == serialiseBoard())    {
            print("start\n------------------------------------")
            print("congratulations, you successfully deserialised your board and serialized it again correctly. You can send your data model over the internet with this code. 1 step closer to network OX ;)")
            
            print("done\n------------------------------------")
        }   else    {
            print("start\n------------------------------------")
            print ("your board deserialisation and serialization was not correct :( carry on coding on those functions")
            
            print("done\n------------------------------------")
        }
        
    }
    
    // Methods
    
    private func deserialiseBoard(boardString: String) -> [CellType] {
        
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
        
        return tempArray
        
    }
    
    private func serialiseBoard() -> String {
        
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
        print(numOfTurns)
        return numOfTurns
    }
    
    func updateTurn() -> CellType {
        if currentTurn == CellType.X {
            currentTurn = CellType.O
        }
        else if currentTurn == CellType.O {
            currentTurn = CellType.X
        }
        return currentTurn
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
    
    func flipTurn() -> CellType {
        // returns a flipped currentTurn
        let temp = updateTurn()
        updateTurn()
        return temp
    }
    
    // Does multiple things:
    // checks whether cell is empty, increases # of turns, updates turns, etc
    func playMove(cellNumber: Int) -> CellType {
        /*
        if board[cellNumber] != CellType.Empty {
            return board[cellNumber]
        }
         */
        numOfTurns += 1
        board[cellNumber] = currentTurn
        print("This is now an \(currentTurn)")
        let temp = currentTurn
        updateTurn()
        return temp
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
        numOfTurns = 0
        currentTurn = startType
    }
    
}
