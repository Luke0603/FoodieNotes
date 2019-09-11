//
//  StoreMaintainInfoViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/9.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GooglePlaces

class StoreMaintainInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var storeImg: UIImageView!
    
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextView!
    
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //storeImg 綁定事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(StoreMaintainInfoViewController.selectUserImg(sender:)))
        storeImg.isUserInteractionEnabled = true
        storeImg.addGestureRecognizer(tap)
        
        storeNameTextField.setBottomBorder()
        telTextField.setBottomBorder()
        websiteTextField.setBottomBorder()
        addressTextField.setBottomBorder()
        priceTextField.setBottomBorder()
    }
    
    @IBAction func setAddressInfo(_ sender: Any) {
        print("=================Address=================")
        addressTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func backToSetUpPage(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    @IBAction func selectUserImg(sender: UITapGestureRecognizer) {
        makeUpView()
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
