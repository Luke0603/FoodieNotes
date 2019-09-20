//
//  MaintainInfoViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/6.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class MaintainInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userNickNameTextField: UITextField!
    
    @IBOutlet weak var userSummaryTextView: UITextView!
    
    let imgPicker = UIImagePickerController()
    
    let usersRef = Database.database().reference(withPath: "users")
    
    let storageRef = Storage.storage().reference(withPath: "users")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usersRef.child(Auth.auth().currentUser!.uid).observe( .value, with: { snapshot in
            if let userData = User(snapshot: snapshot) {
                self.user = userData
                
                let url = URL(string: userData.headShotUrl)
                let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("error")
                        return
                    }
                    DispatchQueue.main.async {
                        self.userImg.image = UIImage(data: data!)
                        self.userNickNameTextField.text = userData.userName
                        self.userSummaryTextView.text = userData.summary
                    }
                })
                task.resume()
            }
        })
        
        //userImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(MaintainInfoViewController.selectUserImg(sender:)))
        userImg.isUserInteractionEnabled = true
        userImg.addGestureRecognizer(tap)
        
        userNickNameTextField.setBottomBorder()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backToSetUpPage(_ sender: Any) {
        
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func maintainSaveAction(_ sender: Any) {
        
        guard let data = self.userImg.image?.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(Auth.auth().currentUser!.uid).putData(data, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("\(String(describing: error))")
            }
            self.storageRef.child(Auth.auth().currentUser!.uid).downloadURL(completion: { (url, error) in
                if error != nil {
                    print("\(String(describing: error))")
                } else {
                    if url?.absoluteString != nil {
                        self.user.headShotUrl = url!.absoluteString
                        self.user.userName = self.userNickNameTextField.text!
                        self.user.summary = self.userSummaryTextView.text!
                        self.usersRef.child(Auth.auth().currentUser!.uid).setValue(self.user.toAnyObject())
                    }
                }
            })
        }
//        self.user.userName = self.userNickNameTextField.text!
//        self.user.summary = self.userSummaryTextView.text!
//        self.usersRef.child(Auth.auth().currentUser!.uid).setValue(self.user.toAnyObject())
        
//        self.usersRef.child(Auth.auth().currentUser!.uid).observe( .value, with: { snapshot in
//            if let userData = User(snapshot: snapshot) {
//                self.user = userData
//                self.user.userName = self.userNickNameTextField.text!
//                self.user.summary = self.userSummaryTextView.text!
//            }
//            self.usersRef.child(Auth.auth().currentUser!.uid).setValue(self.user.toAnyObject())
//        })
        
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func selectUserImg(sender: UITapGestureRecognizer) {
        makeUpView()
    }
    
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
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
