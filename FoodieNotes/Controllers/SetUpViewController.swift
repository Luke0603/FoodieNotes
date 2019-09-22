//
//  SetUpViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/6.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class SetUpViewController: UIViewController {
    
    @IBOutlet weak var maintenanceInfoLabel: UILabel!
    
    @IBOutlet weak var blacklistLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetUpViewController.goToMaintenPage(sender:)))
        maintenanceInfoLabel.isUserInteractionEnabled = true
        maintenanceInfoLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(SetUpViewController.goToBlacklistPage(sender:)))
        blacklistLabel.isUserInteractionEnabled = true
        blacklistLabel.addGestureRecognizer(tap2)
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
            loginButton.setTitle("登出",for: .normal)
        } else {
            loginButton.setTitle("登入",for: .normal)
        }
    }
    
    @IBAction func backToUserProfile(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        
        do {
            // 登出,並導回首頁
            try Auth.auth().signOut()
            Analytics.logEvent("FoodieNotes_SignOut", parameters: ["SignOut_OK": "OK"])
            let userDefaults = UserDefaults.standard
            userDefaults.set("", forKey: UserDefaultKeys.AccountInfo.userType)
            userDefaults.set(false, forKey: UserDefaultKeys.LoginInfo.isLogin)
            userDefaults.synchronize()
            // 登入成功,導回首頁
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController
            
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        } catch (let error) {
            print("Auth sign out failed: \(error)")
            // 顯示失敗訊息
            let controller = UIAlertController(title: "登出失敗", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            Analytics.logEvent("FoodieNotes_SignOut", parameters: ["SignOut_Error": error.localizedDescription])
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToMaintenPage(sender: UITapGestureRecognizer) {
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "StoreMaintainInfoPage") {
                present(controller, animated: false, completion: nil)
            }
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "MaintainInfoPage") {
                present(controller, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func goToBlacklistPage(sender: UITapGestureRecognizer) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "BlacklistNGC") {
            present(controller, animated: false, completion: nil)
        }
    }
}
