//
//  UserController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

class UserController {
    
    // Creatimg a reference to the NSUserData -- a default persistent dictionary
    let defaults = NSUserDefaults.standardUserDefaults()
    
    static var sharedInstance = UserController()
    var currentUser: User?
    private var users = [User]()
    
    func currentUserExists() -> Bool {
        if currentUser != nil {
            return true
        }
        return false
    }
    
    func register(email email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
        // Check if password is smaller than 6 characters
        if password.characters.count < 6 {
            onCompletion(nil, "Password must be longer than 6 characters")
            return
        }
        
        // Check if email is null
        if email == "" {
            onCompletion(nil, "Missing an email address")
            return
        }
        
        // Check if email has been used
        for x in users {
            if email == x.email {
                onCompletion(nil, "Email already used")
                return
            }
        }
        
        // set to current user and append to user list
        currentUser = User(newEmail: email, newPassword: password)
        users.append(currentUser!)
        onCompletion(currentUser, nil)
        
        
        // PERSISTENCE
        // Creating/Overwriting the data
        defaults.setObject(email, forKey: "currentUserEmail")
        defaults.setObject(password, forKey: "currentUserPassword")
        defaults.synchronize()
        // defaults is a reference to the NSUserData
        
    }
    
    func login(email email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
        // Check for existing user
        for x in users {
            if x.email == email && x.password == password {
                currentUser = x
                onCompletion(x, nil)
                
                // PERSISTENCE
                // Creating/Overwriting the data
                defaults.setObject(email, forKey: "currentUserEmail")
                defaults.setObject(password, forKey: "currentUserPassword")
                defaults.synchronize()
                
                return
            }
        }
        
        onCompletion(nil, "Incorrect Username or Password")
        return
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
