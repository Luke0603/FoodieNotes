//
//  StoreMaintainInfoViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/9.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class StoreMaintainInfoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let imgPicker = UIImagePickerController()
    
    let usersRef = Database.database().reference(withPath: "users")
    
    let storageRef = Storage.storage().reference(withPath: "users")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //storeImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(StoreMaintainInfoViewController.selectUserImg(sender:)))
        storeImg.isUserInteractionEnabled = true
        storeImg.addGestureRecognizer(tap)
        
        //        setTextFieldLayer()
        setViewStyle()
        
        self.usersRef.child(Auth.auth().currentUser!.uid).observe( .value, with: { snapshot in
            if let userData = User(snapshot: snapshot) {
                self.user = userData
                
                if !userData.headShotUrl.isEmpty {
                    let url = URL(string: userData.headShotUrl)
                    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("error")
                            return
                        }
                        DispatchQueue.main.async {
                            self.storeImg.image = UIImage(data: data!)
                        }
                    })
                    task.resume()
                }
                self.storeNameTextField.text = userData.userName
                self.telTextField.text = userData.tel
                self.websiteTextField.text = userData.website
                self.addressTextField.text = userData.address
                self.priceTextField.text = String(userData.price)
                self.summaryTextField.text = userData.summary
                self.summaryTextField.textColor = UIColor.black
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setViewStyle() {
        
        priceTextField.delegate = self
        telTextField.delegate = self
        summaryTextField.delegate = self
        
        storeImg.layer.cornerRadius = 60
        storeImg.layer.borderColor = UIColor.gray.cgColor
        storeImg.layer.borderWidth = 1
        
        summaryTextField.layer.cornerRadius = 10
        summaryTextField.text = "Store introduction"
        summaryTextField.textColor = UIColor.lightGray
        
        saveButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }
    
    func setTextFieldLayer() {
        storeNameTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .darkGray, width: 1.0)
        telTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .darkGray, width: 1.0)
        websiteTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .darkGray, width: 1.0)
        addressTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .darkGray, width: 1.0)
        priceTextField.addLine(position: .LINE_POSITION_BOTTOM, color: .darkGray, width: 1.0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Store introduction"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telTextField {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let Range = range.length + range.location > (telTextField.text?.count)!
            
            if Range == false && alphabet == false {
                return false
            }
            
            let NewLength = (telTextField.text?.count)! + string.count - range.length
            return NewLength <= 10
            
        } else if textField == priceTextField {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let Range = range.length + range.location > (priceTextField.text?.count)!
            
            if Range == false && alphabet == false {
                return false
            }
            
            return true
            
        } else {
            return false
        }
    }
    
    @IBAction func setAddressInfo(_ sender: Any) {
        print("=================Address=================")
        addressTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func maintainSaveAction(_ sender: Any) {
        
        if self.storeNameTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "資料檢核", message: "麻煩請輸入「店名」,謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        guard let data = self.storeImg.image?.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(Auth.auth().currentUser!.uid).putData(data, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("!!!ERROR_HERE_[StoreMaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
            }
            self.storageRef.child(Auth.auth().currentUser!.uid).downloadURL(completion: { (url, error) in
                if error != nil {
                    print("!!!ERROR_HERE_[StoreMaintainInfoViewController_MaintainSaveAction]: \(error!.localizedDescription)")
                } else {
                    if url?.absoluteString != nil {
                        self.user.headShotUrl = url!.absoluteString
                    }
                    self.user.userName = self.storeNameTextField.text!
                    self.user.tel = self.telTextField.text!
                    self.user.website = self.websiteTextField.text!
                    self.user.address = self.addressTextField.text!
                    self.user.price = Int(self.priceTextField.text!)!
                    self.user.summary = self.summaryTextField.text!
                    self.usersRef.child(Auth.auth().currentUser!.uid).setValue(self.user.toAnyObject())
                }
            })
        }
        
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func backToSetUpPage(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func selectUserImg(sender: UITapGestureRecognizer) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (_) in
            self.makeUpView()
        }
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            self.storeImg.image = UIImage(named: "Img_user")
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(libraryAction)
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension StoreMaintainInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
            storeImg.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ///關閉ImagePickerController
        picker.dismiss(animated: false, completion: nil)
    }
}

extension StoreMaintainInfoViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        addressTextField.text = place.name
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

