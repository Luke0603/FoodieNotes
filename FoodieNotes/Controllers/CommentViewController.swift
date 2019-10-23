//
//  CommentViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/28.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase
import MessageViewController

class CommentViewController: MessageViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var commentTabelView: UITableView!
    
    var postId: String!
    var comments = [Comment]()
    var users = [User]()
    let ref_comments = Database.database().reference(withPath: "comments")
    let ref_users = Database.database().reference(withPath: "users")
    let storageRef_users = Storage.storage().reference(withPath: "users")
    var post: IndexPost!
    var data = "Lorem ipsum dolor sit amet|consectetur adipiscing elit|sed do eiusmod|tempor incididunt|ut labore et dolore|magna aliqua| Ut enim ad minim|veniam, quis nostrud|exercitation ullamco|laboris nisi ut aliquip|ex ea commodo consequat|Duis aute|irure dolor in reprehenderit|in voluptate|velit esse cillum|dolore eu|fugiat nulla pariatur|Excepteur sint occaecat|cupidatat non proident|sunt in culpa|qui officia|deserunt|mollit anim id est laborum"
        .components(separatedBy: "|")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTabelView.dataSource = self
        commentTabelView.delegate = self
        commentTabelView.separatorStyle = UITableViewCell.SeparatorStyle.none
        commentTabelView.register(UINib(nibName:"CommentTableViewCell", bundle:nil),forCellReuseIdentifier:"CommentTableViewCell")
        //        commentTabelView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        commentTabelView.rowHeight = UITableView.automaticDimension
        view.addSubview(commentTabelView)
        
        borderColor = .lightGray
        
        messageView.inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        messageView.textView.contentInset = .zero
        messageView.font = UIFont.systemFont(ofSize: 18)
        
        messageView.textView.placeholderText = "請輸入訊息..."
        messageView.textView.placeholderTextColor = .lightGray
        
        messageView.setButton(inset: 15, position: .right)
        messageView.setButton(title: "送出", for: .normal, position: .right)
        messageView.addButton(target: self, action: #selector(onRightButton), position: .right)
        messageView.rightButtonTint = .blue
        
        setup(scrollView: commentTabelView)
        
        loadComments()
    }
    
    @IBAction func onRightButton() {
        
        let uniqueString = NSUUID().uuidString
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "YYYY/MM/dd HH:mm:ss"
        let dateString: String = dateFormat.string(from: now)
        var image: UIImage = UIImage(named: "Img_user")!
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.LoginInfo.isLogin) {
            let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.AccountInfo.userName) as? String
            if let imageData = UserDefaults.standard.object(forKey: UserDefaultKeys.AccountInfo.userImg) as? Data {
                image = UIImage(data: imageData) ?? UIImage(named: "Img_user")!
            }
            
            ref_comments.child(postId).child(uniqueString).child("message").setValue(messageView.text)
            ref_comments.child(postId).child(uniqueString).child("createUserId").setValue(Auth.auth().currentUser!.uid)
            ref_comments.child(postId).child(uniqueString).child("createDate").setValue(dateString)
            
            comments.append(Comment.init(Message: messageView.text, UserName: userName!, UserImg: image, CreateDate: dateString))
            messageView.text = ""
            commentTabelView.reloadData()
            commentTabelView.scrollToRow(
                at: IndexPath(row: comments.count - 1, section: 0),
                at: .bottom,
                animated: true
            )
        } else {
            
            let alert = UIAlertController(title: "系統通知", message: "麻煩請登入帳號,謝謝!", preferredStyle: .actionSheet)
            let titleString = NSMutableAttributedString(string: "系統通知")
            let titleRange = NSRange(location: 0, length: titleString.length)
            titleString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Georgia", size: 18.0)!, range: titleRange)
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: titleRange)
            alert.setValue(titleString, forKey: "attributedTitle")
            
            let messageString = NSMutableAttributedString(string: "麻煩請登入帳號,謝謝!")
            let messageRange = NSRange(location: 0, length: titleString.length)
            messageString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Georgia", size: 18.0)!, range: messageRange)
            messageString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: messageRange)
            alert.setValue(messageString, forKey: "attributedMessage")
            
            let okAction = UIAlertAction(title: "確定", style: .default)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            
            messageView.text = ""
        }
    }
    
    func loadComments() {
        ref_comments.child(self.postId).observeSingleEvent(of: .value, with: { snapshot in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                
                guard let restDict = rest.value as? [String: Any] else { continue }
                
                let message = restDict["message"] as? String ?? ""
                let createUserId = restDict["createUserId"] as? String ?? ""
                let createDate = restDict["createDate"] as? String ?? ""
                
                self.ref_users.child(createUserId).observeSingleEvent(of: .value , with: { snapshot in
                    
                    if let userData = User(snapshot: snapshot) {
                        let url = URL(string: userData.headShotUrl!)
                        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            
                            var userImg: UIImage
                            
                            if error != nil {
                                print("!!!ERROR_HERE_[MaintainInfoViewController_ViewDidLoad]: \(error!.localizedDescription)")
                                return
                            }
                            
                            userImg = UIImage(data: data!) ?? UIImage(named: "Img_user")!
                            
                            DispatchQueue.main.async {
                                let comment = Comment.init(Message: message, UserName: userData.userName, UserImg: userImg, CreateDate: createDate)
                                
                                self.comments.append(comment)
                                self.comments.sort(by: { (indexPost1, indexPost2) -> Bool in
                                    indexPost1.createDate < indexPost2.createDate
                                })
                                self.commentTabelView.reloadData()
                            }
                        })
                        task.resume()
                    }
                })
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    //
    //    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
    //        ref_comments.child(id).observeSingleEvent(of: .value, with: {
    //            snapshot in
    //            if let dict = snapshot.value as? [String: Any] {
    //                let newComment = Comment.transformComment(dict: dict)
    //                completion(newComment)
    //            }
    //        })
    //    }
    //
    //    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
    //
    //        self.observeUser(withId: uid, completion: {
    //            user in
    //            self.users.append(user)
    //            completed()
    //        })
    //    }
    //
    //    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
    //        ref_users.child(uid).observeSingleEvent(of: .value, with: {
    //            snapshot in
    //            if (snapshot.value as? [String: Any]) != nil {
    //                let user = User.init(snapshot: <#T##DataSnapshot#>)
    //                completion(user!)
    //            }
    //        })
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        //        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if let commentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell {
            
            let comment = comments[indexPath.item]
            commentTableViewCell.selectionStyle = .none
            commentTableViewCell.commentUserImgView.image = comment.userImg
            commentTableViewCell.commentUserImgView.layer.cornerRadius = (commentTableViewCell.commentUserImgView.frame.width)/2
            commentTableViewCell.commentLabel.text = "\(comment.userName)\n\(comment.message)"
            commentTableViewCell.commentLabel.numberOfLines = 0
            
            cell = commentTableViewCell
        }
        //        cell.selectionStyle = .none
        //        cell.imageView?.image = UIImage(named: "Img_cancel")
        //        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.width)!/2
        //        cell.textLabel?.text = "test\(indexPath.row)\n\(data[indexPath.row])"
        //        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    @IBAction func backToIndexController(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
}
