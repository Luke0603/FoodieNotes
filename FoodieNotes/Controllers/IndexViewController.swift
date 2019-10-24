//
//  IndexViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/20.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class MyTapGesture: UITapGestureRecognizer {
    var post: IndexPost!
    var postId: String!
    var likeCountLabel: UILabel!
    var likeButton: UIButton!
    var selectRowNumber: Int!
}

class IndexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let storageRef_posts = Storage.storage().reference(withPath: "posts")
    let ref_posts = Database.database().reference(withPath: "posts")
    let ref_users = Database.database().reference(withPath: "users")
    let storageRef_users = Storage.storage().reference(withPath: "users")
    let ref_reports = Database.database().reference(withPath: "reports")
    var blackListArray: [String] = []
    var model: IndexTableViewModel!
    var refreshControl: UIRefreshControl!
    var postLives: [PostLive] = []
    var posts: [IndexPost] = []
    var postArray: [Post] = []
    var userArray: [User] = []
    
    @IBOutlet weak var indexTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("============1===========")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("============2===========")
        if let array = UserDefaults.standard.array(forKey: UserDefaultKeys.AccountInfo.userBlackList) as? [String] {
            blackListArray = array
        }
        //        self.getModel()
        //        UserDefaults.standard.set("", forKey: UserDefaultKeys.AccountInfo.userType)
        //        UserDefaults.standard.set(false, forKey: UserDefaultKeys.LoginInfo.isLogin)
        //        print("======>UserType:\(String(describing: UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType)))")
        //        print("======>UserType:\(UserDefaults.standard.string(forKey: UserDefaultKeys.AccountInfo.userType)!)")
        //        print("======>UserType:\(UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin))")
        
        indexTableView.delegate = self
        indexTableView.dataSource = self
        indexTableView.estimatedRowHeight = 200
        indexTableView.rowHeight = UITableView.automaticDimension
        indexTableView.contentInsetAdjustmentBehavior = .never
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中...")
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        indexTableView.addSubview(refreshControl)
        
        self.showSpinner(onView: self.view)
        self.getModel()
        
        Analytics.logEvent("FoodieNotes_IndexView_Start", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        self.showSpinner(onView: self.view)
        //        self.posts.removeAll()
        //        self.getModel()
        //        self.removeSpinner()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData(){
        //        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.getModel()
            if let array = UserDefaults.standard.array(forKey: UserDefaultKeys.AccountInfo.userBlackList) as? [String] {
                self.blackListArray = array
            }
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func getModel() {
        //        postLives.append(PostLive(PostAddUserId: "123", PostDate: "20190825"))
        ref_posts.observeSingleEvent(of: .value, with: { snapshot in
            self.posts.removeAll()
            self.postArray.removeAll()
            print("流程控制============> posts")
            if snapshot.childrenCount != 0 {
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let post = Post(snapshot: snapshot) {
                        
                        if self.blackListArray.contains(post.postAddUserId) {
                            continue
                        }
                        var postImg: UIImage!
                        var userImg: UIImage!
                        
                        if !post.postImg.isEmpty {
                            let url = URL(string: post.postImg)
                            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                if error != nil {
                                    print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                                    return
                                }
                                postImg = UIImage(data: data!)
                                
                                self.ref_users.child(post.postAddUserId).observeSingleEvent( of: .value, with: { snapshot in
                                    print("流程控制============> users")
                                    if let userData = User(snapshot: snapshot) {
                                        let url2 = URL(string: userData.headShotUrl!)
                                        let task2 = URLSession.shared.dataTask(with: url2!, completionHandler: { (data, response, error) in
                                            if error != nil {
                                                print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                                                return
                                            }
                                            userImg = UIImage(data: data!)
                                            
                                            DispatchQueue.main.async {
                                                let indexPost = IndexPost(StoreName: post.storeName, PostImg: postImg, PostContent: post.postContent, PostAddUserId: post.postAddUserId, LikeCount: post.likes.count - 1, MessageCount: post.messageCount, UserName: userData.userName, UserType: userData.userType, HeadShotImg: userImg, PostDate: post.postDate)
                                                
                                                self.posts.append(indexPost)
                                                self.posts.sort(by: { (indexPost1, indexPost2) -> Bool in
                                                    indexPost1.postDate > indexPost2.postDate
                                                })
                                                self.postArray.append(post)
                                                self.postArray.sort(by: { (indexPost1, indexPost2) -> Bool in
                                                    indexPost1.postDate > indexPost2.postDate
                                                })
                                                self.userArray.append(userData)
                                                self.indexTableView.reloadData()
                                                self.removeSpinner()
                                            }
                                        })
                                        task2.resume()
                                    }
                                })
                            })
                            task.resume()
                        }
                        
                        print("HERE_IndexViewController_posts: \(post.storeName)")
                    }
                }
            } else {
                self.removeSpinner()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("post.count=========>\(posts.count)")
        var reCount: Int
        
        if posts.isEmpty {
            reCount = 0
        } else {
            reCount = posts.count
        }
        
        return reCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        //        if let liveCell = indexTableView.dequeueReusableCell(withIdentifier: "LiveTableCell") as? LiveTableViewCell {
        //            cell = liveCell
        //        }
        
        //        if indexPath.item == 0 {
        //            if let liveCell = indexTableView.dequeueReusableCell(withIdentifier: "LiveTableCell") as? LiveTableViewCell {
        //                cell = liveCell
        //            }
        //        } else {
        if let postCell = indexTableView.dequeueReusableCell(withIdentifier: "PostTableCell") as? PostTableViewCell {
            let post = posts[indexPath.item]
            postCell.contentLB.text = post.postContent
            postCell.stroeNameLB.text = post.storeName
            postCell.postImg.image = post.postImg
            postCell.likeCountLB.text = String(post.likeCount)
            postCell.userNameLB.text = post.userName
            postCell.userImg.layer.cornerRadius = 25
            postCell.userImg.image = post.headShotImg
            
            let tap_userNameLB = MyTapGesture(target: self, action: #selector(IndexViewController.goToProfilePage(_:)))
            tap_userNameLB.post = post
            postCell.userNameLB.isUserInteractionEnabled = true
            postCell.userNameLB.addGestureRecognizer(tap_userNameLB)
            
            let tap_likeButton = MyTapGesture(target: self, action: #selector(IndexViewController.didTouchLikeButton(_:)))
            tap_likeButton.likeCountLabel = postCell.likeCountLB
            tap_likeButton.likeButton = postCell.likeButton
            tap_likeButton.selectRowNumber = indexPath.item
            postCell.likeButton.isUserInteractionEnabled = true
            postCell.likeButton.addGestureRecognizer(tap_likeButton)
            let post_org = postArray[indexPath.item]
            if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) && post_org.likes[Auth.auth().currentUser!.uid] != nil {
                postCell.likeButton.setImage(UIImage(named: "Img_like"), for: .normal)
            } else {
                postCell.likeButton.setImage(UIImage(named: "Img_unlike"), for: .normal)
            }
            
            let tap_messageImg = MyTapGesture(target: self, action: #selector(IndexViewController.didTouchCommentImg(_:)))
            tap_messageImg.post = post
            tap_messageImg.postId = postArray[indexPath.item].ref!.key
            postCell.messageImg.isUserInteractionEnabled = true
            postCell.messageImg.addGestureRecognizer(tap_messageImg)
            
            let tap_repost = MyTapGesture(target: self, action: #selector(IndexViewController.didTouchReportImg(_:)))
            tap_repost.selectRowNumber = indexPath.item
            postCell.reportImgView.isUserInteractionEnabled = true
            postCell.reportImgView.addGestureRecognizer(tap_repost)
            
            cell = postCell
        }
        //        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? LiveTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    @IBAction func didTouchReportImg(_ sender: MyTapGesture) {
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
            let post = postArray[sender.selectRowNumber]
            let alert = UIAlertController(title: "檢舉", message: nil, preferredStyle: .actionSheet)
            let titleString = NSMutableAttributedString(string: "檢舉")
            let titleRange = NSRange(location: 0, length: titleString.length)
            titleString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Georgia", size: 15.0)!, range: titleRange)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: titleRange)
            alert.setValue(titleString, forKey: "attributedTitle")
            
            let spamAction = UIAlertAction(title: "這是垃圾訊息", style: .default) { _ in
                self.ref_reports.child((post.ref?.key)!).child("reportMessage").setValue("這是垃圾訊息")
                self.ref_reports.child((post.ref?.key)!).child("reportUser").setValue(Auth.auth().currentUser!.uid)
                self.ref_reports.child((post.ref?.key)!).child("reportPost").setValue((post.ref?.key)!)
            }
            spamAction.setValue(UIColor.black, forKey: "titleTextColor")
            
            let discomfortAction = UIAlertAction(title: "內容不適當", style: .default) { _ in
                self.ref_reports.child((post.ref?.key)!).child("reportMessage").setValue("內容不適當")
                self.ref_reports.child((post.ref?.key)!).child("reportUser").setValue(Auth.auth().currentUser!.uid)
                self.ref_reports.child((post.ref?.key)!).child("reportPost").setValue((post.ref?.key)!)
            }
            discomfortAction.setValue(UIColor.black, forKey: "titleTextColor")
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alert.addAction(spamAction)
            alert.addAction(discomfortAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTouchLikeButton(_ sender: MyTapGesture) {
        
        let likeButton = sender.likeButton!
        let likeCountLabel = sender.likeCountLabel!
        let post = postArray[sender.selectRowNumber]
        let likeCount = Int(likeCountLabel.text!)
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
            if likeButton.imageView!.image!.isEqual(UIImage(named: "Img_unlike")) {
                
                likeButton.setImage(UIImage(named: "Img_like"), for: .normal)
                likeCountLabel.text = String(likeCount! + 1)
                
                self.ref_posts.child((post.ref?.key)!).child("likes").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser!.uid)
            } else {
                
                likeButton.setImage(UIImage(named: "Img_unlike"), for: .normal)
                likeCountLabel.text = String(likeCount! - 1)
                
                self.ref_posts.child((post.ref?.key)!).child("likes").child(Auth.auth().currentUser!.uid).removeValue { error, _ in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func didTouchCommentImg(_ sender: MyTapGesture) {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "CommentNGC") {
            if let commentViewController = controller.children[0] as? CommentViewController {
                commentViewController.postId = sender.postId
                present(controller, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func goToProfilePage(_ sender: MyTapGesture) {
        let post = sender.post
        
        if !UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) || post?.postAddUserId != Auth.auth().currentUser?.uid {
            
            if let controller = storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileNGC") {
                if let otherProfileViewController = controller.children[0] as? OtherProfileViewController {
                    otherProfileViewController.post = post
                    present(controller, animated: false, completion: nil)
                }
            }
        } else {
            
            self.tabBarController!.selectedIndex = 2
        }
    }
}

extension IndexViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postLives.count
        //        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionCell", for: indexPath)
        
        return cell
    }
}

var vSpinner : UIView?

extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
