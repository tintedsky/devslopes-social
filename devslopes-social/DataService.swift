//
//  DataService.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-19.
//  Copyright © 2017 Udemy. All rights reserved.
//

import Foundation
import Firebase


// Here is a good example for singleton

let DB_BASE = Database.database().reference()

class DataService{
    static let ds = DataService()  // 'static' means global accessible
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        //The reason we use updateChildValues instead of setValues because here we do not want to wape out the existing information in database.
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
