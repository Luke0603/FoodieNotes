//
//  Comment.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/10/11.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    
    var message: String
    var userName: String
    var userImg: UIImage
    var createDate: String
    
    init(Message message: String, UserName userName: String, UserImg userImg: UIImage, CreateDate createDate: String) {
        
        self.message = message
        self.userName = userName
        self.userImg = userImg
        self.createDate = createDate
    }
}
