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
    var userFansCount: Int = 0
    var userFollowsCount: Int = 0
    let ref_users = Database.database().reference(withPath: "users")
    let storageRef_users = Storage.storage().reference(withPath: "users")
    let storageRef_posts = Storage.storage().reference(withPath: "posts")
    let ref_posts = Database.database().reference(withPath: "posts")
    let ref_fans = Database.database().reference(withPath: "fans")
    let ref_follows = Database.database().reference(withPath: "follows")
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
        userTableView.estimatedRowHeight = 44.0
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.contentInsetAdjustmentBehavior = .never
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            userTableView.register(UINib(nibName:"StoreTableViewCell", bundle:nil),forCellReuseIdentifier:"StoreTableViewCell")
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            userTableView.register(UINib(nibName:"UserTableViewCell", bundle:nil),forCellReuseIdentifier:"UserTableViewCell")
        }
        
        loadData()
        loadCountData()
    }
    
    func loadData() {
        
        if Auth.auth().currentUser != nil {
            self.ref_users.child(Auth.auth().currentUser!.uid).observeSingleEvent( of: .value, with: { snapshot in
                if let userData = User(snapshot: snapshot) {
                    var userImg: UIImage!
                    let url = URL(string: userData.headShotUrl!)
                    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                            return
                        }
                        userImg = UIImage(data: data!)
                        
                        DispatchQueue.main.async {
                            self.userImg = userImg
                            self.user = userData
                            self.userTableView.reloadData()
                        }
                        
                        self.ref_posts.queryOrdered(byChild: "postAddUserId").queryEqual(toValue: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
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
                                                self.userPosts.sort(by: { (indexPost1, indexPost2) -> Bool in
                                                    indexPost1.postDate > indexPost2.postDate
                                                })
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
        }
    }
    
    func loadCountData() {
        
        if Auth.auth().currentUser != nil {
            
            ref_fans.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                
                self.userFansCount = Int(snapshot.childrenCount) - 1
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            })
            
            ref_follows.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                
                self.userFollowsCount = Int(snapshot.childrenCount) - 1
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            })
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
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.store {
            if let storeTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell") as? StoreTableViewCell {
                
                storeTableViewCell.storeImg.image = self.userImg
                storeTableViewCell.storeImg.layer.cornerRadius = storeTableViewCell.storeImg.frame.width / 2
                storeTableViewCell.storeNameLabel.text = self.user.userName
                storeTableViewCell.storeFansCountLabel.text = String(self.userFansCount)
                storeTableViewCell.storeFollowCountLabel.text = String(self.userFollowsCount)
                storeTableViewCell.storeSummaryLabel.text = self.user.summary
                storeTableViewCell.storePosts = self.userPosts
                storeTableViewCell.storePriceLabel.text = "\n平均價位：\(self.user.price!)"
                
                if self.user.latitude != 0 && self.user.longitude != 0 {
                    
                    let camera = GMSCameraPosition.camera(withLatitude: self.user.latitude!, longitude: self.user.longitude!, zoom: 15.0)
                    storeTableViewCell.storeMapView.camera = camera
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: self.user.latitude!, longitude: self.user.longitude!)
                    marker.title = self.user.address
                    marker.snippet = self.user.address
                    marker.map = storeTableViewCell.storeMapView
                } else {
                    
                    let camera = GMSCameraPosition.camera(withLatitude: 25.0602993, longitude: 121.5210402, zoom: 15.0)
                    storeTableViewCell.storeMapView.camera = camera
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: 25.0602993, longitude: 121.5210402)
                    marker.title = "Taiwan"
                    marker.snippet = "Taipei101"
                    marker.map = storeTableViewCell.storeMapView
                }
                
                storeTableViewCell.frame = tableView.bounds
                storeTableViewCell.layoutIfNeeded()
                
                //重新加载单元格数据
                storeTableViewCell.reloadData()
                
                cell = storeTableViewCell
            }
        } else if UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType) == Constant.UserType.user {
            if let userTableViewCell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell {
                
                userTableViewCell.userImg.image = self.userImg
                userTableViewCell.userImg.layer.cornerRadius = userTableViewCell.userImg.frame.width / 2
                userTableViewCell.userNameLabel.text = self.user.userName
                userTableViewCell.userFansCountLabel.text = String(self.userFansCount)
                userTableViewCell.userFollowCountLabel.text = String(self.userFollowsCount)
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
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
    }
}
