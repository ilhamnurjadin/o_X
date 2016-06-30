//
//  UserController.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

class UserController {
    
    static var sharedInstance = UserController()
    var currentUser: User?
    private var users = [User]()
    
    func currentUserExists() -> Bool {
        if currentUser != nil {
            return true
        }
        return false
    }
    
    func register(email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
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
        
        let tempUser = User(newEmail: email, newPassword: password)
        onCompletion(tempUser, nil)
        
        // set to current user and append to user list
        currentUser = tempUser
        users.append(tempUser)
        
    }
    
    func login(email: String, password: String, onCompletion: (User?, String?) -> Void) {
        
        let tempUser = User(newEmail: email, newPassword: password)
        
        // Check for existing user
        for x in users {
            if x.equals(tempUser) {
                onCompletion(tempUser, nil)
                return
            }
        }
        
        onCompletion(nil, "Incorrect Username or Password")
        currentUser = tempUser
        
    }
    
    func logout(onCompletion: (String?) -> Void) {
        currentUser = nil
        onCompletion(nil)
    }
    
}
