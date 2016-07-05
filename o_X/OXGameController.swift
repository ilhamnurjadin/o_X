//
//  OXGameController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/29/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
import SwiftyJSON

// Model Controller

class OXGameController: WebService {
    
    static let sharedInstance = OXGameController()
    override private init() {}                      // should this override?
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
    
    func getGameList(onCompletion onCompletion: ([OXGame]?, String?) -> Void) {
        
        // Creating user as a dictionary
        
        // CREATING A REQUEST
        // A request has 4 things:
        // 1. An endpoint
        // 2. A method
        // 3. Some input data (optional)
        // 4. A response
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games"), method: "GET")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                var arrayOfGames = [OXGame]()
                
                //If json is .Array
                //The `index` is 0..<json.count's string value
                for (index,subJson):(String, JSON) in json {
                    let tempGame = OXGame()
                    tempGame.ID = subJson["id"].intValue
                    tempGame.host = subJson["host_user"]["email"].stringValue
                    arrayOfGames.append(tempGame)
                }
                
                onCompletion(arrayOfGames, "Games Found")
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
    }
    
}

