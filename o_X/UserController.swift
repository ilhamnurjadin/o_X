//
//  UserController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation
import Alamofire

class UserController: WebService {
    
    // Creatimg a reference to the NSUserData -- a default persistent dictionary
    let defaults = NSUserDefaults.standardUserDefaults()
    
    static var sharedInstance = UserController()
    var currentUser: User?
    
    func register(email email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
        // Creating user as a dictionary
        let user = ["email": email, "password": password]
        
        // CREATING A REQUEST
        // A request has 4 things:
        // 1. An endpoint
        // 2. A method
        // 3. Some input data (optional)
        // 4. A response
        
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth"), method: "POST", parameters: user)
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be competed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if (serverResponseCode / 100 == 2) {
                
                let tempUser = User(newEmail: json["data"]["email"].stringValue, newPassword: "not stored", newClient: json["data"]["client"].stringValue, newToken: json["data"]["token"].stringValue)
                
                self.currentUser = tempUser
                
                // PERSISTENCE
                // Creating/Overwriting the data
                self.defaults.setObject(tempUser.email, forKey: "currentUserEmail")
                self.defaults.setObject(password, forKey: "currentUserPassword")
                self.defaults.synchronize()
                print("register")
                
                onCompletion(tempUser, "Registration Successful")
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }

        }
        
    }
   
    func login(email email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
        // Creating user as a dictionary
        let user = ["email": email, "password": password]
        
        // CREATING A REQUEST
        // A request has 4 things:
        // 1. An endpoint
        // 2. A method
        // 3. Some input data (optional)
        // 4. A response
        
        let request = self.createMutableAnonRequest(NSURL(string: "https://ox-backend.herokuapp.com/auth/sign_in"), method: "POST", parameters: user)
        
        // Execute Request
        self.executeRequest(request) { serverResponseCode, json in
            
            // If request could not be competed
            if serverResponseCode == 0 {
                onCompletion(nil, "Request could not be completed.")
                return
            }
            
            // If request could be completed
            if serverResponseCode == 200 {
                
                let tempUser = User(newEmail: json["data"]["email"].stringValue, newPassword: "not stored", newClient: json["data"]["client"].stringValue, newToken: json["data"]["token"].stringValue)
                
                self.currentUser = tempUser
                
                // PERSISTENCE
                // Creating/Overwriting the data
                self.defaults.setObject(email, forKey: "currentUserEmail")
                self.defaults.setObject(password, forKey: "currentUserPassword")
                self.defaults.synchronize()
                print("login")
                
                onCompletion(tempUser, "Login Successful")
                
            }
            else {
                onCompletion(nil, json["errors"]["full_messages"].arrayValue[0].stringValue)
            }
            
        }
        
        // defaults is a reference to the NSUserData
        
    }
    
    func logout(onCompletion onCompletion: (String?) -> Void) {
        currentUser = nil
        onCompletion(nil)
        defaults.removeObjectForKey("currentUserEmail")
        defaults.removeObjectForKey("currentUserPassword")
        defaults.synchronize()
    }
    
}
