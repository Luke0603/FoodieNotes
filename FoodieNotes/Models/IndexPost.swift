//
//  IndexPost.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/23.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation
import UIKit

class IndexPost {

    var storeName: String //店名
    var postImg: UIImage //貼文圖片
    var postContent: String //貼文內容
    var postAddUserId: String //貼文User
    var likeCount: Int //like次數
    var messageCount: Int //留言次數
    var userName: String //店名 or 姓名
    var userType: String //使用者種類
    var headShotImg: UIImage //Logo or 大頭貼儲存連結
    var postDate : String //貼文creatDate
    
    init(StoreName storeName: String, PostImg postImg: UIImage, PostContent postContent: String, PostAddUserId postAddUserId: String, LikeCount likeCount: Int, MessageCount messageCount: Int, UserName userName: String, UserType userType: String, HeadShotImg headShotImg: UIImage, PostDate postDate: String) {
        
        self.storeName = storeName
        self.postImg = postImg
        self.postContent = postContent
        self.postAddUserId = postAddUserId
        self.likeCount = likeCount
        self.messageCount = messageCount
        self.userName = userName
        self.userType = userType
        self.headShotImg = headShotImg
        self.postDate = postDate
    }
}
