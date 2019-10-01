//
//  MainTabBarViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Crashlytics

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 || item.tag == 2 {
            print("isLogin========================\(UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin))")
            if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                
                self.present(loginViewController, animated: false, completion: nil)
                
                self.selectedIndex = 0
            } else {
//                if item.tag == 1 {
//                    let controller = self.viewControllers![item.tag] as! AddPostViewController
//                    controller.viewDidLoad()
//                }
            }
            print("=============Here============")
        } else {
//            if item.tag == 0 {
//                let controller = self.viewControllers![item.tag] as! IndexViewController
//                controller.viewDidLoad()
//            }
        }
    }
}
