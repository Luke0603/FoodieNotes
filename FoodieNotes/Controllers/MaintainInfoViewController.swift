//
//  MaintainInfoViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/6.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class MaintainInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userNickNameTextField: UITextField!
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //userImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(MaintainInfoViewController.selectUserImg(sender:)))
        userImg.isUserInteractionEnabled = true
        userImg.addGestureRecognizer(tap)
        
        userNickNameTextField.setBottomBorder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToSetUpPage(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func selectUserImg(sender: UITapGestureRecognizer) {
        makeUpView()
    }
    
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.white.cgColor
        
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
