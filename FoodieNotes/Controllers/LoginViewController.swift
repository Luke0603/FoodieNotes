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
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                
                let alert = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                Analytics.logEvent("FoodieNotes_SignIn_Error", parameters: nil)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                guard let uid = result?.user.uid else {
                    return
                }
                
                self.usersRef.child(uid).observeSingleEvent( of: .value, with: { snapshot in
                    
                    guard
                        let info = snapshot.value as? [String: Any],
                        let userType = info["userType"] as? String,
                        let userName = info["userName"] as? String,
                        let userImgUrl = info["headShotUrl"] as? String
                        else { return }
                    
                    let url2 = URL(string: userImgUrl)
                    let task2 = URLSession.shared.dataTask(with: url2!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            UserDefaults.standard.set(userType, forKey: UserDefaultKeys.AccountInfo.userType)
                            
                            UserDefaults.standard.set(true, forKey: UserDefaultKeys.LoginInfo.isLogin)
                            
                            UserDefaults.standard.set(UIImage(data: data!)!.jpegData(compressionQuality: 1.0), forKey: UserDefaultKeys.AccountInfo.userImg)
                            
                            UserDefaults.standard.set(userName, forKey: UserDefaultKeys.AccountInfo.userName)
                            
                            Analytics.logEvent("FoodieNotes_SignIn_OK", parameters: ["SignIn_OK_Email": email])
                            
                            // 登入成功,導回首頁
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController
                            
                            appDelegate.window?.rootViewController = initialViewController
                            
                            appDelegate.window?.makeKeyAndVisible()
                        }
                    })
                    task2.resume()
                    
                    
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
