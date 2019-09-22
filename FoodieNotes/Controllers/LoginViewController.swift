//
//  LoginViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/19.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    let usersRef = Database.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginDidTouch(_ sender: Any) {
        
        guard
            let email = textFieldLoginEmail.text,
            let password = textFieldLoginPassword.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                Analytics.logEvent("FoodieNotes_SignIn_Error", parameters: nil)
                self.present(alert, animated: true, completion: nil)
            } else {
                var user: User!
                var uid: String = ""
                
                if let user = Auth.auth().currentUser{
                    uid = user.uid
                    
                }
                
                self.usersRef.child(uid).observe( .value, with: { snapshot in
                    if let userData = User(snapshot: snapshot) {
                        user = userData
                    }
                    
                    UserDefaults.standard.set(user.userType, forKey: UserDefaultKeys.AccountInfo.userType)
                    UserDefaults.standard.set(true, forKey: UserDefaultKeys.LoginInfo.isLogin)
                    Analytics.logEvent("FoodieNotes_SignIn_OK", parameters: ["SignIn_OK_Email": email])
                    // 登入成功,導回首頁
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController
                    
                    appDelegate.window?.rootViewController = initialViewController
                    appDelegate.window?.makeKeyAndVisible()
                })
                
                
            }
        }
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") {
            present(controller, animated: false, completion: nil)
        }
    }
    
    
    @IBAction func backDidTouch(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let indexViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController
        
        indexViewController.selectedIndex = 0
        
        present(indexViewController, animated: false, completion: nil)
        
        //        dismiss(animated: false, completion: nil) // 返回前一頁
    }
}
