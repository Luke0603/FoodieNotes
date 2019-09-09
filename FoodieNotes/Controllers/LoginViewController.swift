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
        
        // 1 監聽
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                //                self.performSegue(withIdentifier: "", sender: nil)
                self.textFieldLoginEmail.text = nil
                self.textFieldLoginPassword.text = nil
            }
        }
        // Do any additional setup after loading the view.
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
                let alert = UIAlertController(title: "Login Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
            }
        }
        
        usersRef.child(Auth.auth().currentUser?.uid ?? "")
        
    }
    
    @IBAction func signUpDidTouch(_ sender: Any) {
        
        let alert = UIAlertController(title: "註冊新帳號",
                                      message: "請輸入Email,Password以便登入,感謝!!",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // 1
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            // 2
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    // 3
                    Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
                                       password: self.textFieldLoginPassword.text!)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backDidTouch(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let indexViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController

        indexViewController.selectedIndex = 0
        
        present(indexViewController, animated: false, completion: nil)
        
        //        dismiss(animated: false, completion: nil) // 返回前一頁
    }
}
