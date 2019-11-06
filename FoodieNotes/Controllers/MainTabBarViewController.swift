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
        
//        if item.tag == 1 || item.tag == 2 {
//
//            if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//
//                loginViewController.mainTabbarViewController = self
//                self.present(loginViewController, animated: false, completion: nil)
//            }
//            print("=============Here============")
//        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        if viewController.tabBarItem.tag == 1 || viewController.tabBarItem.tag == 2 {

            if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController

                loginViewController.mainTabbarViewController = self
                self.present(loginViewController, animated: false, completion: nil)

                return false
            }
        }

        return true
    }
}
