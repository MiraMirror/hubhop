//
//  Post.swift
//  Hubhop
//
//  Created by Xuan Yang on 9/28/15.
//  Copyright © 2015 MiraCode. All rights reserved.
//

import Foundation


class Post {
    private var _postDescription: String!
    private var _imageUrl: String? // user may not upload an image
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    init(description: String, username: String, imageUrl: String?){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
    }
}

