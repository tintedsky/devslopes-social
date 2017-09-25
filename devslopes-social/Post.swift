//
//  Post.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-20.
//  Copyright © 2017 Udemy. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _caption:String!
    private var _imageUrl:String!
    private var _likes:Int!
    private var _postKey: String!
    private var _postRef:DatabaseReference!
    
    var caption:String{
        return _caption
    }
    
    var imageUrl:String{
        return _imageUrl
    }
    
    var likes:Int{
        return _likes
    }
    
    var postKey:String{
        return _postKey
    }
    
    init(caption:String, imageUrl:String, likes:Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    //postData was missing
    init(postKey:String, postData:Dictionary<String, Any>){
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    //adjust likes
    func adjustLikes(like: Bool){
        if like{
            _likes = _likes + 1
        }else{
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
