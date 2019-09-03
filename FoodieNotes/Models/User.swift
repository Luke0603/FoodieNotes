//
//  User.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/20.
//  Copyright © 2019 Luke. All rights reserved.
//  使用者資訊

import Foundation
import Firebase

class User {
    
    let ref: DatabaseReference?
    var userType : String //0->店家, 1->一般用戶
    var userName : String //店名 or 姓名
    var birthday : String //生日
    var gender : String //性別
    var tel : String //電話
    var email : String //Email
    var website : String //網站
    var address : String //地址
    var price : Int //平均價位
    var summary : String //簡介
    var headShotUrl : String //Logo or 大頭貼儲存連結
    var storePicUrl_array : [String] //店家介紹圖片
    
    init(UserType userType : String, UserName userName : String, Birthday birthday : String, Gender gender : String, Tel tel : String, Email email : String, Website website : String, Address address : String, Price price : Int, Summary summary : String, HeadShotUrl headShotUrl : String, StorePicUrl_array storePicUrl_array : [String]) {
        
        self.ref = nil
        self.userType = userType
        self.userName = userName
        self.birthday = birthday
        self.gender = gender
        self.tel = tel
        self.email = email
        self.website = website
        self.address = address
        self.price = price
        self.summary = summary
        self.headShotUrl = headShotUrl
        self.storePicUrl_array = storePicUrl_array
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject] else {
                return nil
        }
        
        let userType = value["userType"] as? String
        let userName = value["userName"] as? String
        let birthday = value["birthday"] as? String
        let gender = value["gender"] as? String
        let tel = value["tel"] as? String
        let email = value["email"] as? String
        let website = value["website"] as? String
        let address = value["address"] as? String
        let price = value["price"] as? Int
        let summary = value["summary"] as? String
        let headShotUrl = value["headShotUrl"] as? String
        let storePicUrl_array = value["storePicUrl_array"] as? [String]
        
        self.ref = snapshot.ref
        self.userType = userType!
        self.userName = userName!
        self.birthday = birthday!
        self.gender = gender!
        self.tel = tel!
        self.email = email!
        self.website = website!
        self.address = address!
        self.price = price!
        self.summary = summary!
        self.headShotUrl = headShotUrl!
        self.storePicUrl_array = storePicUrl_array!
        
    }
    
    func toAnyObject() -> Any {
        return [
            "userType" : userType,
            "userName" : userName,
            "birthday" : birthday,
            "gender" : gender,
            "tel" : tel,
            "email" : email,
            "website" : website,
            "address" : address,
            "price" : price,
            "summary" : summary,
            "headShotUrl" : headShotUrl,
            "storePicUrl" : storePicUrl_array
        ]
    }
}
