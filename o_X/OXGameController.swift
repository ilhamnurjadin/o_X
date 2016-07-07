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
    
    // Offline
    func playMove(cellNumber: Int) -> CellType {
        return currentGame.playMove(cellNumber)
    }
    
    func getStateInString(bool: Bool) -> String {
        if bool {
            switch currentGame.state() {
            case OXGameState.Won:
                if (self.currentGame.whoseTurn().opposite() == .X && amIHost()) || (self.currentGame.whoseTurn().opposite() == .O && !amIHost()) {
                    return "You Win!"
                }
                else {
                    return "You Lose!"
                }
            case OXGameState.Tie:
                return "It's a Tie!"
            default:
                if (self.currentGame.whoseTurn() == .X && amIHost()) || (self.currentGame.whoseTurn() == .O && !amIHost()) {
                    return "Your Turn"
                }
                else {
                    return "Opponent's Turn"
                }
            }
        }
        switch currentGame.state() {
        case OXGameState.Won:
            return "\(self.currentGame.whoseTurn().opposite()) Wins!"
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
    
    func joinGame(game_id: Int, onCompletion: (OXGame?, String?) -> Void) {
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/\(game_id)/join"), method: "GET")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                let tempGame = OXGame()
                
                tempGame.deserialiseBoard(json["board"].stringValue)
                tempGame.ID = json["id"].intValue
                tempGame.host = json["host_user"]["uid"].stringValue
                
                self.currentGame = tempGame
                
                onCompletion(tempGame, nil)
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }

    }
    
    func createNewGame(onCompletion onCompletion: (OXGame?, String?) -> Void) {
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/"), method: "POST")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                let tempGame = OXGame()
                
                tempGame.deserialiseBoard(json["board"].stringValue)
                tempGame.ID = json["id"].intValue
                tempGame.host = json["host_user"]["uid"].stringValue
                
                self.currentGame = tempGame
                
                onCompletion(tempGame, "Games Connected")
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
    }
    
    //Online
    func playMove(onCompletion onCompletion: (OXGame?, String?) -> Void) {
        
        let boardString = ["board": currentGame.serialiseBoard()]
        print(boardString)
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/\(self.currentGame.ID)"), method: "PUT", parameters: boardString)
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                self.currentGame.deserialiseBoard(json["board"].stringValue)
                self.currentGame.ID = json["id"].intValue
                self.currentGame.host = json["host_user"]["uid"].stringValue
                
                onCompletion(self.currentGame, nil)
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
    }
    
    func refreshGame(onCompletion onCompletion: (OXGame?, Bool?, String?) -> Void) {
        // bool to identify if game is open (false) or closed (true)
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/\(self.currentGame.ID)"), method: "GET")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(nil, nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                self.currentGame.deserialiseBoard(json["board"].stringValue)
                self.currentGame.ID = json["id"].intValue
                self.currentGame.host = json["host_user"]["uid"].stringValue
                
                if json["state"] == "closed" {
                    onCompletion(self.currentGame, true, nil)
                }
                else {
                    onCompletion(self.currentGame, false, nil)
                }
                
            }
            else {
                onCompletion(nil, nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
    }
    
    func cancelGame(onCompletion onCompletion: (String?) -> Void) {
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/\(self.currentGame.ID)"), method: "DELETE")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion("Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                // reset game
                let tempGame = OXGame()
                self.currentGame = tempGame
                
                onCompletion(nil)
                
            }
            else {
                onCompletion(json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
    }
    
    func amIHost() -> Bool {
        if OXGameController.sharedInstance.getCurrentGame().host == UserController.sharedInstance.currentUser?.email {
            return true
        }
        else {
            return false
        }
    }
    
    /*
    func gameHasGuest(onCompletion onCompletion: (Bool, String?) -> Void) {
        
        let request = self.createMutableRequest(NSURL(string: "https://ox-backend.herokuapp.com/games/\(self.currentGame.ID)"), method: "GET")
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be completed
            if serverResponseCode == 0 {
                onCompletion(false, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                if json["guest_user"] != nil {
                    onCompletion(true, nil)
                }
                else {
                    onCompletion(false, nil)
                }
                
            }
            else {
                onCompletion(false, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
    }
    */
    
}

