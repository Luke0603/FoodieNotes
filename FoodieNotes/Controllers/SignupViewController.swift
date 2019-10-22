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
    @IBOutlet weak var nickNameTextField: UITextField!
    
    let usersRef = Database.database().reference(withPath: "users")
    let storageRef = Storage.storage().reference(withPath: "users")
    let fansRef = Database.database().reference(withPath: "fans")
    let followsRef = Database.database().reference(withPath: "follows")
    let userTypeArray = ["請選擇角色", "店家", "吃貨"]
    var userType: String = ""
    var userType_UserDefault: String = ""
    var checkSelectRow: Int = 0
    var selectRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.alertUserTypePicker(sender:)))
        userTypeLabel.isUserInteractionEnabled = true
        userTypeLabel.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func alertUserTypePicker(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "請選擇註冊角色(＊)", message: "\n\n", preferredStyle: .alert)
        let myPickerView = UIPickerView(frame: CGRect(x: 80, y: 35, width: 100 , height: 60))
        myPickerView.delegate = self
        myPickerView.dataSource = self
        alert.view.addSubview(myPickerView)
        
        let saveAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.userTypeLabel.text = self.userType
            self.checkSelectRow = self.selectRow
        }
        
        let cancelAction = UIAlertAction(title: "BACK", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didSignUp(_ sender: Any) {
        
        if self.emailTextField.text?.isEmpty == true {
            
            let controller = UIAlertController(title: "資料檢核", message: "E-mail忘記輸入了!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if self.passwordTextField.text?.isEmpty == true {
            
            let controller = UIAlertController(title: "資料檢核", message: "Password忘記輸入了!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if self.nickNameTextField.text?.isEmpty == true {
            
            let controller = UIAlertController(title: "資料檢核", message: "暱稱忘記輸入了!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if self.checkSelectRow == 0 {
            
            let controller = UIAlertController(title: "資料檢核", message: "還沒有選擇角色喔!!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            return
        } else if self.checkSelectRow == 1 {
            userType_UserDefault = Constant.UserType.store
        } else if self.checkSelectRow == 2 {
            userType_UserDefault = Constant.UserType.user
        }
        
        // 註冊帳號
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (result, error) in
            if error == nil {
                
                guard let resultUser = result?.user else { return }
                
                // 成功註冊後登入
                Auth.auth().signIn(withEmail: resultUser.uid, password: resultUser.email!)
                
                guard let data = UIImage(named: "Img_user")?.jpegData(compressionQuality: 1.0) else { return }
                
                let metaData = StorageMetadata()
                
                metaData.contentType = "image/jpg"
                
                self.storageRef.child(resultUser.uid).putData(data, metadata: metaData) { (metadata, error) in
                    if error != nil {
                        
                        print("!!!ERROR_HERE_[MaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
                    }
                    self.storageRef.child(Auth.auth().currentUser!.uid).downloadURL(completion: { (url, error) in
                        if error != nil {
                            
                            print("!!!ERROR_HERE_[MaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
                        } else {
                            
                            if url?.absoluteString != nil {
                                
                                let userref = self.usersRef.child(resultUser.uid)
                                
                                let user = User.init(uid: resultUser.uid, email: resultUser.email!, userType: self.userType_UserDefault, userName: self.nickNameTextField.text!)
                                
                                user.headShotUrl = url?.absoluteString
                                
                                userref.setValue(user.toAnyObject())
                                
                                self.fansRef.child(resultUser.uid).child("Init").setValue("Init")
                                
                                self.followsRef.child(resultUser.uid).child("Init").setValue("Init")
                                
                                UserDefaults.standard.set(user.userType, forKey: UserDefaultKeys.AccountInfo.userType)
                                
                                UserDefaults.standard.set(true, forKey: UserDefaultKeys.LoginInfo.isLogin)
                                
                                UserDefaults.standard.set(data, forKey: UserDefaultKeys.AccountInfo.userImg)
                                
                                UserDefaults.standard.set(self.nickNameTextField.text!, forKey: UserDefaultKeys.AccountInfo.userName)
                                
                                Analytics.logEvent("FoodieNotes_SignUp_OK", parameters: ["SignUp_OK_Email": self.emailTextField.text!])
                                // 登入成功,導回首頁
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let initialViewController = storyboard.instantiateViewController(withIdentifier: "indexTB") as! MainTabBarViewController
                                
                                appDelegate.window?.rootViewController = initialViewController
                                
                                appDelegate.window?.makeKeyAndVisible()
                            }
                        }
                    })
                }
            } else {
                // 顯示失敗訊息
                let controller = UIAlertController(title: "註冊失敗", message: error?.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                controller.addAction(okAction)
                
                Analytics.logEvent("FoodieNotes_SignUp_Error", parameters: nil)
                
                self.present(controller, animated: true, completion: nil)
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
