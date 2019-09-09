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
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetUpViewController.goToMaintenPage(sender:)))
        maintenanceInfoLabel.isUserInteractionEnabled = true
        maintenanceInfoLabel.addGestureRecognizer(tap)
        
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
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MaintainInfoPage") {
            present(controller, animated: false, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
