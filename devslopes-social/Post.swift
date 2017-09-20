//
//  Post.swift
//  devslopes-social
//
//  Created by Hongbo Niu on 2017-09-20.
//  Copyright © 2017 Udemy. All rights reserved.
//

import Foundation

class Post{
    private var _caption:String!
    private var _imageUrl:String!
    private var _likes:Int!
    private var _postKey: String!
    
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
    init(postKey:String, postData:Dictionary<String, AnyObject>){
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
    }
}
