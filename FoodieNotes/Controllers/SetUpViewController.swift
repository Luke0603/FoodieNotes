//
//  SetUpViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/6.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class SetUpViewController: UIViewController {
    
    @IBOutlet weak var maintenanceInfoLabel: UILabel!
    
    @IBOutlet weak var blacklistLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetUpViewController.goToMaintenPage(sender:)))
        maintenanceInfoLabel.isUserInteractionEnabled = true
        maintenanceInfoLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(SetUpViewController.goToBlacklistPage(sender:)))
        blacklistLabel.isUserInteractionEnabled = true
        blacklistLabel.addGestureRecognizer(tap2)
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
            loginButton.title = "登出"
        } else {
            loginButton.title = "登入"
        }
    }
    
    @IBAction func backToUserProfile(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
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
