//
//  MaintainInfoViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/6.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class MaintainInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNickNameTextField: UITextField!
    @IBOutlet weak var userSummaryTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let imgPicker = UIImagePickerController()
    
    let usersRef = Database.database().reference(withPath: "users")
    
    let storageRef = Storage.storage().reference(withPath: "users")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //userImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(MaintainInfoViewController.selectUserImg(sender:)))
        userImg.isUserInteractionEnabled = true
        userImg.addGestureRecognizer(tap)
        
        setViewStyle()
        
        self.usersRef.child(Auth.auth().currentUser!.uid).observeSingleEvent( of: .value, with: { snapshot in
            
            if let userData = User(snapshot: snapshot) {
                self.user = userData
                
                guard let userHeadShotUrl = userData.headShotUrl else { return }
                
                    let url = URL(string: userHeadShotUrl)
                
                    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                            return
                        }
                        DispatchQueue.main.async {
                            self.userImg.image = UIImage(data: data!)
                            
                        }
                    })
                    task.resume()
                
                self.userNickNameTextField.text = userData.userName
                self.userSummaryTextView.text = userData.summary
                self.userSummaryTextView.textColor = UIColor.black
            }
        })
    }
    
    func setViewStyle() {
        
        userSummaryTextView.delegate = self
        userSummaryTextView.layer.cornerRadius = 10
        userSummaryTextView.text = "介紹自己吧..."
        userSummaryTextView.textColor = UIColor.lightGray
        
        userImg.layer.cornerRadius = 60
        userImg.layer.borderColor = UIColor.gray.cgColor
        userImg.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "介紹自己吧..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backToSetUpPage(_ sender: Any) {
        
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func maintainSaveAction(_ sender: Any) {
        
        if self.userNickNameTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "資料檢核", message: "麻煩請輸入「暱稱」,謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        guard let data = self.userImg.image?.jpegData(compressionQuality: 1.0) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(Auth.auth().currentUser!.uid).putData(data, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("!!!ERROR_HERE_[MaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
            }
            self.storageRef.child(Auth.auth().currentUser!.uid).downloadURL(completion: { (url, error) in
                if error != nil {
                    print("!!!ERROR_HERE_[MaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
                } else {
                    if url?.absoluteString != nil {
                        self.user.headShotUrl = url!.absoluteString
                        self.user.userName = self.userNickNameTextField.text!
                        self.user.summary = self.userSummaryTextView.text!
                        self.usersRef.child(Auth.auth().currentUser!.uid).setValue(self.user.toAnyObject())
                        UserDefaults.standard.set(data, forKey: UserDefaultKeys.AccountInfo.userImg)
                        UserDefaults.standard.set(self.userNickNameTextField.text!, forKey: UserDefaultKeys.AccountInfo.userName)
                        self.dismiss(animated: false, completion: nil) // 返回前一頁
                    }
                }
            })
        }
//
//        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func selectUserImg(sender: UITapGestureRecognizer) {
        makeUpView()
    }
    
    
}

extension MaintainInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func makeUpView() {
        print("makeUpView")
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ///關閉ImagePickerController
        picker.dismiss(animated: false, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            ///取得使用者選擇的圖片
            userImg.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ///關閉ImagePickerController
        picker.dismiss(animated: false, completion: nil)
    }
}
