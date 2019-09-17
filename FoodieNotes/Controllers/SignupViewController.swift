//
//  SignupViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/17.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    //    let fullScreenSize = UIScreen.main.bounds.size
    let userTypeArray = ["請選擇角色", "店家", "吃貨"]
    var userType: String = ""
    var checkSelectRow: Int = 0
    var selectRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.alertUserTypePicker(sender:)))
        userTypeLabel.isUserInteractionEnabled = true
        userTypeLabel.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func alertUserTypePicker(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "請選擇註冊角色(＊)", message: "\n\n", preferredStyle: .alert)
        let myPickerView = UIPickerView(frame: CGRect(x: 80, y: 35, width: 100 , height: 60))
        myPickerView.delegate = self
        myPickerView.dataSource = self
        alert.view.addSubview(myPickerView)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            self.userTypeLabel.text = self.userType
            self.checkSelectRow = self.selectRow
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didSignUp(_ sender: Any) {
        
        // 1
        if self.emailTextField.text?.isEmpty == true {
            
            let controller = UIAlertController(title: "資料檢核", message: "E-mail忘記輸入了!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return
        }
        
        if self.passwordTextField.text?.isEmpty == true {
            
            let controller = UIAlertController(title: "資料檢核", message: "Password忘記輸入了!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return
        }
        
        if self.checkSelectRow == 0 {
            
            let controller = UIAlertController(title: "資料檢核", message: "還沒有選擇角色喔!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return
        }
        
        // 註冊帳號
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { user, error in
            if error == nil {
                // 成功註冊後登入
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)

                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                let initialViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController

                appDelegate.window?.rootViewController = initialViewController

                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func backToLoginPage(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypeArray[row]
    }
    
    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.userType = userTypeArray[row]
        self.selectRow = row
        
        print("pickerView -> userType: \(userType)")
    }
}
