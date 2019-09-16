//
//  AddPostViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/27.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController {
    
    var userDefault: UserDefaults!
    
    let ref = Database.database().reference(withPath: "User-items")
    
    var user: User?
    
    let headerView = AddSimplePostViewController()
    
    //    let userId: String = "1234556678"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureViewCon = AddSimplePostViewController(nibName: "AddSimplePostViewController", bundle: nil)
        captureViewCon.rootTabbarController = self.tabBarController!
        self.present(captureViewCon, animated: true, completion: nil)
        //        self.addChild(headerView)
        //        self.view.addSubview(headerView.view)
        //        headerView.didMove(toParent: self)
        //        headerView.view.frame = CGRect(x:0, y: 0, width: view.frame.width, height: view.frame.height)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //        ref.queryOrdered(byChild: "1234556678").observe(.value, with: { snapshot in
        //            for child in snapshot.children {
        //                if let snapshot = child as? DataSnapshot,
        //                    let item = User(snapshot: snapshot) {
        //                    print("getUserInfoById")
        //                    self.user = item
        //
        //
        //                }
        //            }
        //        })
    }
}

//extension AddPostViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        
//        guard let currentVC = viewController as? PageVC else {
//            return nil
//        }
//        
//        var index = currentVC.page.index
//        
//        if index == 0 {
//            return nil
//        }
//        
//        index -= 1
//        
//        let vc: PageVC = PageVC(with: pages[index])
//        
//        return vc
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        
//        guard let currentVC = viewController as? PageVC else {
//            return nil
//        }
//        
//        var index = currentVC.page.index
//        
//        if index >= self.pages.count - 1 {
//            return nil
//        }
//        
//        index += 1
//        
//        let vc: PageVC = PageVC(with: pages[index])
//        
//        return vc
//    }
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.pages.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return self.currentIndex
//    }
//}
