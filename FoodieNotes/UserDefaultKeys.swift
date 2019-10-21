//
//  UserDefaultKeys.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    
    // 帳號
    struct AccountInfo {
    
        static let userType = "userType"
        
        static let userName = "userName"
        
        static let userImg = "userImg"
        
        static let userBlackList = "userBlackList"
    }
    
    // 登入資料
    struct LoginInfo {
        
        static let isLogin = "isLogin"
    }
}
