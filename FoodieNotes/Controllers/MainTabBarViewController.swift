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
        if item.tag == 1 {
            if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
                let alert = UIAlertController(title: "尚未登入",message: "請先登入/註冊帳號,謝謝!!",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.selectedIndex = 0
                    // guard let myTabBarController = self.tabBarController else {return}
                    // myTabBarController.selectedIndex = 0
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            print("=============Here============")
        }
    }
}
