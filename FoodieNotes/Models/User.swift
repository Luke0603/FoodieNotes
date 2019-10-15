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
    
//    let ref: DatabaseReference? = nil
    var uid: String
    var email: String
    var userType: String //0->店家, 1->一般用戶
    var userName: String //店名 or 姓名
    var tel: String? //電話
    var website: String? //網站
    var address: String? //地址
    var price: Int? //平均價位
    var summary: String? //簡介
    var headShotUrl: String? //Logo or 大頭貼儲存連結
    
//    init(authData: Firebase.User) {
//        
//        self.uid = authData.uid
//        self.email = authData.email!
//    }
    
    init(uid: String, email: String, userType: String, userName: String) {
        
        self.uid = uid
        self.email = email
        self.userType = userType
        self.userName = userName
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject] else {
                return nil
        }
        
        let uid = value["uid"] as? String
        let userType = value["userType"] as? String
        let userName = value["userName"] as? String
        let tel = value["tel"] as? String
        let email = value["email"] as? String
        let website = value["website"] as? String
        let address = value["address"] as? String
        let price = value["price"] as? Int
        let summary = value["summary"] as? String
        let headShotUrl = value["headShotUrl"] as? String
        
        self.uid = uid!
        self.userType = userType!
        self.userName = userName!
        self.tel = tel!
        self.email = email!
        self.website = website!
        self.address = address!
        self.price = price!
        self.summary = summary!
        self.headShotUrl = headShotUrl!
        
    }
    
    func toAnyObject() -> Any {
        
        let tel = self.tel != nil ? self.tel : ""
        let website = self.website != nil ? self.website : ""
        let address = self.address != nil ? self.address : ""
        let price = self.price != nil ? self.price : 0
        let summary = self.summary != nil ? self.summary : ""
        let headShotUrl = self.headShotUrl != nil ? self.headShotUrl : ""
        
        return [
            "uid" : uid,
            "email" : email,
            "userType" : userType,
            "userName" : userName,
            "tel" : tel!,
            "website" : website!,
            "address" : address!,
            "price" : price!,
            "summary" : summary!,
            "headShotUrl" : headShotUrl!
        ]
    }
//    init(UserType userType : String, UserName userName : String, Birthday birthday : String, Gender gender : String, Tel tel : String, Email email : String, Website website : String, Address address : String, Price price : Int, Summary summary : String, HeadShotUrl headShotUrl : String) {
//
//        self.ref = nil
//        self.userType = userType
//        self.userName = userName
//        self.birthday = birthday
//        self.gender = gender
//        self.tel = tel
//        self.email = email
//        self.website = website
//        self.address = address
//        self.price = price
//        self.summary = summary
//        self.headShotUrl = headShotUrl
//    }
    
    
}
