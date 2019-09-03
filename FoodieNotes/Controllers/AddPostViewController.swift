//
//  AddPostViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/27.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imgPicker = UIImagePickerController()
    
    var userDefault: UserDefaults!
    
    let ref = Database.database().reference(withPath: "User-items")
    
    var user: User?
    
    //    let userId: String = "1234556678"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        ref.queryOrdered(byChild: "1234556678").observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let item = User(snapshot: snapshot) {
                    print("getUserInfoById")
                    self.user = item
                    
                    
                }
            }
        })
    }
    
    func makeUpView() {
        print("makeUpView")
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        guard let myTabBarController = self.tabBarController else {return}
        
        myTabBarController.selectedIndex = 0
        
        picker.dismiss(animated: true, completion: nil)
        
        print("Here =========> imagePickerControllerDidCancel")
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: {
            var img:UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if picker.allowsEditing {
                img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            }
            print(img ?? "No select Img!!")
        })
        
        // 取得照片
        //        picker.dismiss(animated: true, completion: nil)
        //取得照片後將imagePickercontroller dismiss
        print("Here =========> didFinishPickingMediaWithInfo")
    }
}
