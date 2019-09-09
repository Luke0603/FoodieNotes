//
//  MainTabBarViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 || item.tag == 2 {
            
            if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                
                self.present(loginViewController, animated: false, completion: nil)
                
                self.selectedIndex = 0
                //                let alert = UIAlertController(title: "尚未登入",message: "請先登入/註冊帳號,謝謝!!",preferredStyle: .alert)
                //
                //                let backAction = UIAlertAction(title: "返回", style: .default) { _ in
                //                    self.selectedIndex = 0
                //
                //                }
                //
                //                alert.addAction(backAction)
                
                //                self.present(alert, animated: true, completion: nil)
            }
            print("=============Here============")
        }
    }
    
    //        else if item.tag == 2 {
    //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    //            let userProfileViewController = storyboard.instantiateViewController(withIdentifier: "userProfileVC") as! UserProfileViewController
    
    //            print("userType: \(UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) ?? "No UserType!!!!!")")
    //            if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
    //                userProfileViewController.userTableView.isHidden = false
    //                userProfileViewController.storeTableView.isHidden = true
    //            } else {
    //                userProfileViewController.userTableView.isHidden = true
    //                userProfileViewController.storeTableView.isHidden = false
    //            }
    //        }
}
