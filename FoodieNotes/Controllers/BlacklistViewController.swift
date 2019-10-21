//
//  BlacklistViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/10.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import Firebase

class BlackUserInfo {
    var userId: String
    var userName: String
    var userImg: UIImage
    
    init(UserId userId: String, UserName userName: String, UserImg userImg: UIImage) {
        
        self.userId = userId
        self.userName = userName
        self.userImg = userImg
    }
}

class BlacklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var blacklistTableView: UITableView!
    
    let ref_users = Database.database().reference(withPath: "users")
    let storageRef_users = Storage.storage().reference(withPath: "users")
    let model = generateRandomData()
    var blackListData: [BlackUserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blacklistTableView.delegate = self
        blacklistTableView.dataSource = self
        blacklistTableView.separatorStyle = .none
        blacklistTableView.estimatedRowHeight = 44.0
        blacklistTableView.rowHeight = UITableView.automaticDimension
        blacklistTableView.contentInsetAdjustmentBehavior = .never
        blacklistTableView.register(UINib(nibName:"BlacklistTableViewCell", bundle:nil),forCellReuseIdentifier:"BlacklistTableViewCell")
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
        blackListData.removeAll()
        if let array = UserDefaults.standard.array(forKey: UserDefaultKeys.AccountInfo.userBlackList) as? [String] {
            if !array.isEmpty {
                for userId in array {
                    self.ref_users.child(userId).observeSingleEvent( of: .value, with: { snapshot in
                        if let userData = User(snapshot: snapshot) {
                            var userImg: UIImage!
                            let url = URL(string: userData.headShotUrl!)
                            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                if error != nil {
                                    print("!!!ERROR_HERE_[BlacklistViewController_ViewDidLoad]: \(error!.localizedDescription)")
                                    userImg = UIImage(named: "Img_user")
                                }
                                userImg = UIImage(data: data!)
                                
                                DispatchQueue.main.async {
                                    let blackUser = BlackUserInfo.init(UserId: userData.uid, UserName: userData.userName, UserImg: userImg)
                                    self.blackListData.append(blackUser)
                                    self.blacklistTableView.reloadData()
                                }
                            })
                            task.resume()
                        }
                    })
                }
            } else {
                blacklistTableView.reloadData()
            }
        }
    }
    
    @IBAction func backToSetUpPag(_ sender: Any) {
        dismiss(animated: false, completion: nil) // 返回前一頁
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if let blacklistTableViewCell = blacklistTableView.dequeueReusableCell(withIdentifier: "BlacklistTableViewCell") as? BlacklistTableViewCell {
            
            let blackUserInfo = blackListData[indexPath.item]
            blacklistTableViewCell.blacklistUserName.text = blackUserInfo.userName
            blacklistTableViewCell.blacklistUserImg.image = blackUserInfo.userImg
            blacklistTableViewCell.blacklistUserImg.layer.cornerRadius = blacklistTableViewCell.blacklistUserImg.frame.width / 2
            blacklistTableViewCell.blacklistRemoveButton.tag = indexPath.item
            blacklistTableViewCell.blacklistRemoveButton.layer.cornerRadius = 10
            blacklistTableViewCell.blacklistRemoveButton.clipsToBounds = true
            blacklistTableViewCell.blacklistRemoveButton.addTarget(self,action: #selector(BlacklistViewController.removeBlacklist(_:)), for: .touchUpInside)
            cell = blacklistTableViewCell
        }
        
        return cell
    }
    
    @IBAction func removeBlacklist(_ sender:UIButton) {
        print("============REMOVE!!!!===============")
        
        if var array = UserDefaults.standard.array(forKey: UserDefaultKeys.AccountInfo.userBlackList) as? [String] {
            let userInfo = blackListData[sender.tag]
            array.removeAll{ $0 == userInfo.userId }
            UserDefaults.standard.set(array, forKey: UserDefaultKeys.AccountInfo.userBlackList)
            loadData()
        }
    }
    
}
