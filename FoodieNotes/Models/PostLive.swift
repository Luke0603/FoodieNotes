//
//  PostLive.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/26.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation
import Firebase

class PostLive {
    
    let ref: DatabaseReference?
    var postAddUserId: String
    var postDate: String
    
    init(PostAddUserId postAddUserId : String, PostDate postDate : String) {
        
        self.ref = nil
        self.postAddUserId = postAddUserId
        self.postDate = postDate
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject] else {
                return nil
        }
        
        let postAddUserId = value["postAddUserId"] as? String
        let postDate = value["postDate"] as? String
        
        self.ref = snapshot.ref
        self.postAddUserId = postAddUserId!
        self.postDate = postDate!
        
    }
    
    func toAnyObject() -> Any {
        return [
            "postAddUserId" : postAddUserId,
            "postDate" : postDate
        ]
    }
    
    
    
    
    
}
