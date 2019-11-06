//
//  AddSimplePostViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/12.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class AddSimplePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imgPicker = UIImagePickerController()
    var rootTabbarController = UITabBarController()
    var mainStoryboard: UIStoryboard?
    let storageRef = Storage.storage().reference(withPath: "posts")
    let postRef = Database.database().reference(withPath: "posts")
    var keyboardHeight: CGFloat = CGFloat()
    var selectedEditTextField: UITextField?
    var selectedEditTextView: UITextView?
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet weak var postStoreNameTextField: UITextField!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postStoreAddressTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //postImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddSimplePostViewController.selectPostImg(sender:)))
        postImg.isUserInteractionEnabled = true
        postImg.addGestureRecognizer(tap)
        
        setViewStyle()
        
    }
    
    @IBAction func selectPostImg(sender: UITapGestureRecognizer) {
        makeUpView()
    }
    
    func setViewStyle() {
        postStoreAddressTextField.layer.cornerRadius = 5
        postContentTextView.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }
    
    func makeUpView() {
        print("makeUpView")
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
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
        
        if self.postStoreNameTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "資料檢核", message: "麻煩請輸入「店名」,謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if self.postStoreAddressTextField.text?.isEmpty == true {
            let controller = UIAlertController(title: "資料檢核", message: "麻煩請輸入「地址」,謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        if self.postImg.image!.isEqual(UIImage(named: "Img_foodPost")) {
            let controller = UIAlertController(title: "資料檢核", message: "麻煩請選擇「照片」,謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            
            self.present(controller, animated: true, completion: nil)
            return
        }
        
        guard let data = self.postImg.image?.jpegData(compressionQuality: 0.7) else { return }
        let uniqueString = NSUUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(uniqueString).putData(data, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("!!!ERROR_HERE_[AddSimplePostViewController_savePostButton]: \(error!.localizedDescription)")
            }
            self.storageRef.child(uniqueString).downloadURL(completion: { (url, error) in
                if error != nil {
                    print("!!!ERROR_HERE_[AddSimplePostViewController_savePostButton]: \(error!.localizedDescription)")
                } else {
                    var img_url: String!
                    let now: Date = Date()
                    let dateFormat: DateFormatter = DateFormatter()
                    dateFormat.dateFormat = "YYYY/MM/dd HH:mm:ss"
                    let dateString: String = dateFormat.string(from: now)
                    
                    if url?.absoluteString != nil {
                        img_url = url!.absoluteString
                    }
                    
                    let newPost: Post = Post(StoreName: self.postStoreNameTextField.text!, StoreAddress: self.postStoreAddressTextField.text!, PostImg: img_url, PostContent: self.postContentTextView.text!, PostDate: dateString, PostAddUserId: Auth.auth().currentUser!.uid, LikeCount: 0, MessageCount: 0, Liles: ["Init" : "Init"], Latitude: self.latitude, Longitude: self.longitude)
                    
                    self.postRef.child(uniqueString).setValue(newPost.toAnyObject())
                    self.rootTabbarController.selectedIndex = 0
                    let controller = self.rootTabbarController.viewControllers![0] as! IndexViewController
                    controller.getModel()
                    self.dismiss(animated: false, completion: nil) // 返回前一頁
                }
            })
        }
    }
    
    @IBAction func cancelPostButton(_ sender: Any) {
        self.rootTabbarController.selectedIndex = 0
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func editingDidBeginStoreName(_ sender: Any) {
        
        if let controller = mainStoryboard!.instantiateViewController(withIdentifier: "SearchViewControllerNGC") as? UINavigationController {
            if let serchViewController = controller.children[0] as? SearchViewController {
                serchViewController.uiViewController = self
                present(controller, animated: false, completion: nil)
            }
        }
    }
}
