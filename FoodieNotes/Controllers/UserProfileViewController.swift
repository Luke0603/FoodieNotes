//
//  UserProfileViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userImg: UIImage!
    var user: User!
    var userPosts: [IndexPost] = []
    let ref_users = Database.database().reference(withPath: "users")
    let storageRef_users = Storage.storage().reference(withPath: "users")
    let storageRef_posts = Storage.storage().reference(withPath: "posts")
    let ref_posts = Database.database().reference(withPath: "posts")
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
        userTableView.estimatedRowHeight = 44.0
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.contentInsetAdjustmentBehavior = .never
        
        self.ref_users.child(Auth.auth().currentUser!.uid).observe( .value, with: { snapshot in
            if let userData = User(snapshot: snapshot) {
                var userImg: UIImage!
                let url = URL(string: userData.headShotUrl)
                let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                        return
                    }
                    userImg = UIImage(data: data!)
                    
                    self.ref_posts.queryOrdered(byChild: "postAddUserId").queryEqual(toValue: Auth.auth().currentUser!.uid).observe(.value, with: { snapshot in
                        self.userPosts.removeAll()
                        for child in snapshot.children {
                            if let snapshot = child as? DataSnapshot,
                                let post = Post(snapshot: snapshot) {
                                var postImg: UIImage!
                                
                                if !post.postImg.isEmpty {
                                    let url = URL(string: post.postImg)
                                    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                        if error != nil {
                                            print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                                            return
                                        }
                                        postImg = UIImage(data: data!)
                                        
                                        DispatchQueue.main.async {
                                            let indexPost = IndexPost(StoreName: post.storeName, PostImg: postImg, PostContent: post.postContent, PostAddUserId: post.postAddUserId, LikeCount: post.likeCount, MessageCount: post.messageCount, UserName: userData.userName, UserType: userData.userType, HeadShotImg: userImg, PostDate: post.postDate)
                                            
                                            self.userPosts.append(indexPost)
                                            self.userImg = userImg
                                            self.user = userData
                                            self.userTableView.reloadData()
                                        }
                                        
                                    })
                                    task.resume()
                                }
                            }
                        }
                    })
                    
                })
                task.resume()
            }
        })
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            userTableView.register(UINib(nibName:"StoreTableViewCell", bundle:nil),forCellReuseIdentifier:"StoreTableViewCell")
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            userTableView.register(UINib(nibName:"UserTableViewCell", bundle:nil),forCellReuseIdentifier:"UserTableViewCell")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var reCount: Int
        
        if user != nil {
            reCount = 1
        } else {
            reCount = 0
        }
        
        return reCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        print("cellForRowAt!!!!")
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            if let storeTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as? StoreTableViewCell {
                
                storeTableViewCell.storeNameLabel.text = "Luke Chen"
                storeTableViewCell.storeFansCountLabel.text = "10000"
                storeTableViewCell.storeFollowCountLabel.text = "20000"
                storeTableViewCell.storeSummaryLabel.text = "hello everyone my name is XXX\n i like XXX\n i want be a XXX\n nice to meet you!!!!!!!!!!!!!!!!!!!!!\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX\n i like XXX\n i want be a XXX!!!!!!!!!!!!!"
                storeTableViewCell.storePriceLabel.text = "平均價位:1000"
                
                print("GMSCameraPosition<============ Start!!!!!")
                // 將視角切換至台北 101
                let camera = GMSCameraPosition.camera(withLatitude: 25.033671, longitude: 121.564427, zoom: 15.0)
                storeTableViewCell.storeMapView.camera = camera
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427)
                marker.title = "Taiwan"
                marker.snippet = "Taipei101"
                marker.map = storeTableViewCell.storeMapView
                print("GMSCameraPosition<============ End!!!!!")
                
                storeTableViewCell.frame = tableView.bounds
                storeTableViewCell.layoutIfNeeded()
                
                //重新加载单元格数据
                storeTableViewCell.reloadData()
                
                cell = storeTableViewCell
            }
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            if let userTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell {
                
                userTableViewCell.userImg.image = self.userImg
                userTableViewCell.userNameLabel.text = self.user.userName
                userTableViewCell.userFansCountLabel.text = "10000"
                userTableViewCell.userFollowCountLabel.text = "20000"
                userTableViewCell.userSummaryLabel.text = self.user.summary
                userTableViewCell.userPosts = self.userPosts
                
                userTableViewCell.frame = tableView.bounds
                userTableViewCell.layoutIfNeeded()
                
                //重新加载单元格数据
                userTableViewCell.reloadData()
                
                cell = userTableViewCell
            }
        }
        
        
        return cell
    }
    
    @IBAction func goToSetUpPage(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SetUpPageNGC") {
            present(controller, animated: false, completion: nil)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        print("forRowAt!!!!")
//
//        guard let userPostsTableViewCell = cell as? UserTableViewCell else { return }
//
//        userPostsTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//
//        userPostsTableViewCell.frame = tableView.bounds
//
//        userPostsTableViewCell.layoutIfNeeded()
//    }
}

//extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("model[collectionView.tag].count: \(model[collectionView.tag].count)")
//        return model[collectionView.tag].count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        var cell: UICollectionViewCell = UICollectionViewCell()
//        
//        if let userPostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionViewCell", for: indexPath) as? UserPostsCollectionViewCell {
//            cell = userPostsCollectionCell
//        }
//        
//        return cell
//    }
//}

