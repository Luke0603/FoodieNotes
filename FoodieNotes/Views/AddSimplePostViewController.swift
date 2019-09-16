//
//  AddSimplePostViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/12.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GooglePlaces

class AddSimplePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imgPicker = UIImagePickerController()
    
    var rootTabbarController = UITabBarController()
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var postStoreAddressTextField: UITextField!
    
    @IBOutlet weak var postContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //postImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddSimplePostViewController.selectPostImg(sender:)))
        postImg.isUserInteractionEnabled = true
        postImg.addGestureRecognizer(tap)
        
    }
    
    @IBAction func selectPostImg(sender: UITapGestureRecognizer) {
        makeUpView()
    }
    
    func makeUpView() {
        print("makeUpView")
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: {
            var img:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if picker.allowsEditing {
                print(info[UIImagePickerController.InfoKey.editedImage] ?? "No Img!!!")
                img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            }
            self.postImg.image = img
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ///關閉ImagePickerController
        picker.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func savePostButton(_ sender: Any) {
        
        self.rootTabbarController.selectedIndex = 0
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func cancelPostButton(_ sender: Any) {
        
        self.rootTabbarController.selectedIndex = 0
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
}
