//
//  IndexTableViewModel.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/26.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation

class IndexTableViewModel {
    
    var postLives: [PostLive]
    var posts: [Post]
    
    init(PostLives postLives: [PostLive], Posts posts: [Post]) {
        self.postLives = postLives
        self.posts = posts
    }
}
