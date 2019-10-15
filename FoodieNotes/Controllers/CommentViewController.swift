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
    let ref_post_comments = Database.database().reference().child("post_comments")
    let ref_users = Database.database().reference(withPath: "users")
    var post: IndexPost!
    var data = "Lorem ipsum dolor sit amet|consectetur adipiscing elit|sed do eiusmod|tempor incididunt|ut labore et dolore|magna aliqua| Ut enim ad minim|veniam, quis nostrud|exercitation ullamco|laboris nisi ut aliquip|ex ea commodo consequat|Duis aute|irure dolor in reprehenderit|in voluptate|velit esse cillum|dolore eu|fugiat nulla pariatur|Excepteur sint occaecat|cupidatat non proident|sunt in culpa|qui officia|deserunt|mollit anim id est laborum"
        .components(separatedBy: "|")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTabelView.dataSource = self
        commentTabelView.delegate = self
        commentTabelView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    }
    
    @IBAction func onRightButton() {
        data.append(messageView.text)
        messageView.text = ""
        commentTabelView.reloadData()
        commentTabelView.scrollToRow(
            at: IndexPath(row: data.count - 1, section: 0),
            at: .bottom,
            animated: true
        )
    }
    
//    func loadComments() {
//        ref_post_comments.child(self.postId).observe(.childAdded, with: {
//            snapshot in
//            self.observeComments(withPostId: snapshot.key, completion: {
//                comment in
//                self.fetchUser(uid: comment.uid!, completed: {
//                    self.comments.append(comment)
//                    self.commentTabelView.reloadData()
//                })
//            })
//        })
//    }
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: "Img_cancel")
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.width)!/2
        cell.textLabel?.text = "test\(indexPath.row)\n\(data[indexPath.row])"
        cell.textLabel?.numberOfLines = 0
        
        
        return cell
    }
    
    @IBAction func backToIndexController(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
}
