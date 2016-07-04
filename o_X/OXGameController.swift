//
//  OXGameController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

// Model Controller
class OXGameController {
    
    static let sharedInstance = OXGameController()
    private init() {}
    private var currentGame = OXGame()
    
    func getCurrentGame() -> OXGame {
        return currentGame
    }
    
    func restartGame() {
        currentGame.reset()
    }
    
    func playMove(cellNumber: Int) -> CellType {
        return currentGame.playMove(cellNumber)
    }
    
    func getStateInString() -> String {
        switch currentGame.state() {
        case OXGameState.Won:
            return "\(self.currentGame.flipTurn()) Wins!"
        case OXGameState.Tie:
            return "It's a Tie!"
        default:
            return "\(self.currentGame.whoseTurn())'s Turn"
        }
    }
    
    func getGames(onCompletion onCompletion: ([OXGame]?, String?) -> Void) {
        onCompletion([OXGame(), OXGame(), OXGame()], nil)
    }
    
}

