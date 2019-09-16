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
            } else {
                
                if item.tag == 1 {
                    let controller = self.viewControllers![item.tag] as! AddPostViewController
                    controller.viewDidLoad()
                }
                //                if let controller = storyboard?.instantiateViewController(withIdentifier: "addPostVC") {
                //                    present(controller, animated: false, completion: nil)
                //                }
                //                let captureViewCon = AddSimplePostViewController(nibName: "AddSimplePostViewController", bundle: nil)
                //                self.present(captureViewCon, animated: true, completion: nil)
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
