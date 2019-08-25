//
//  Post.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/26.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    let ref: DatabaseReference?
    var storeName : String //店名
    var storeAddress : String //店家地址
    var postImg : [String] //貼文圖片
    var postContent : String //貼文內容
    var postTag : String //貼文標籤
    var postDate : String //貼文creatDate
    var postAddUserId : String //貼文User
    var likeCount : Int //like次數
    var messageCount : Int //留言次數
    
    init(StoreName storeName : String, StoreAddress storeAddress : String, PostImg postImg : [String], PostContent postContent : String, PostTag postTag : String, PostDate postDate : String, PostAddUserId postAddUserId : String, LikeCount likeCount : Int, MessageCount messageCount : Int) {
        
        self.ref = nil
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.postImg = postImg
        self.postContent = postContent
        self.postTag = postTag
        self.postDate = postDate
        self.postAddUserId = postAddUserId
        self.likeCount = likeCount
        self.messageCount = messageCount
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject] else {
                return nil
        }
        
        let storeName = value["storeName"] as? String
        let storeAddress = value["storeAddress"] as? String
        let postImg = value["postImg"] as? [String]
        let postContent = value["postContent"] as? String
        let postTag = value["postTag"] as? String
        let postDate = value["postDate"] as? String
        let postAddUserId = value["postAddUserId"] as? String
        let likeCount = value["likeCount"] as? Int
        let messageCount = value["messageCount"] as? Int
        
        self.ref = snapshot.ref
        self.storeName = storeName!
        self.storeAddress = storeAddress!
        self.postImg = postImg!
        self.postContent = postContent!
        self.postTag = postTag!
        self.postDate = postDate!
        self.postAddUserId = postAddUserId!
        self.likeCount = likeCount!
        self.messageCount = messageCount!
        
    }
    
    func toAnyObject() -> Any {
        return [
            "storeName" : storeName,
            "storeAddress" : storeAddress,
            "postImg" : postImg,
            "postContent" : postContent,
            "postTag" : postTag,
            "postDate" : postDate,
            "postAddUserId" : postAddUserId,
            "likeCount" : likeCount,
            "messageCount" : messageCount
        ]
    }
}
