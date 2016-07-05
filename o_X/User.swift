//
//  User.swift
//  o_X
//
//  Created by Ilham Nurjadin on 6/30/16.
//  Copyright © 2016 iX. All rights reserved.
//

import Foundation

class User {
    
    var email:String = ""
    var password:String = ""
    var token:String = ""
    var client:String = ""
    
    init(newEmail: String, newPassword: String, newClient: String, newToken: String) {
        email = newEmail
        password = newPassword
        client = newClient
        token = newToken
    }
    
}
