//
//  Comment.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/10/11.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation

class Comment {
    var commentText: String?
    var uid: String?
}

extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
