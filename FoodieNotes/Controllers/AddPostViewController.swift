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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //目前只提供一般貼文,等之後新增直播
        let captureViewCon = AddSimplePostViewController(nibName: "AddSimplePostViewController", bundle: nil)
        captureViewCon.rootTabbarController = self.tabBarController!
        captureViewCon.mainStoryboard = self.storyboard!
        self.present(captureViewCon, animated: true, completion: nil)
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
