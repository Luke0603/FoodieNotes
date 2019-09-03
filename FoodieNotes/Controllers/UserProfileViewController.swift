//
//  UserProfileViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let model = generateRandomData()
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.estimatedRowHeight = 200
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.contentInsetAdjustmentBehavior = .never

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("model.count: \(model.count)")
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if indexPath.item == 0 {
            if let userNameCell = userTableView.dequeueReusableCell(withIdentifier: "UserNameTableCell") as? UserNameTableViewCell {
                
                userNameCell.userNameLabel.text = "Luke Chen"
                
                cell = userNameCell
            }
        } else if indexPath.item == 1 {
            if let userFollowCell = userTableView.dequeueReusableCell(withIdentifier: "UserFollowTableCell") as? UserFollowTableViewCell {
                
                userFollowCell.userFansCountLabel.text = "10000"
                userFollowCell.userFollowCountLabel.text = "20000"
                
                cell = userFollowCell
            }
        } else if indexPath.item == 2 {
            if let userSummaryCell = userTableView.dequeueReusableCell(withIdentifier: "UserSummaryTableCell") as? UserSummaryTableViewCell {
                
                userSummaryCell.userSummaryLabel.text = "hello everyone my name is XXX\n i like XXX\n i want be a XXX\n nice to meet you!!!!!!!!!!!!!!!!!!!!!"
                
                cell = userSummaryCell
            }
        } else {
            if let userPostsCell = userTableView.dequeueReusableCell(withIdentifier: "UserPostsTableCell") as? UserPostsTableViewCell {
                
                cell = userPostsCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let userPostsTableViewCell = cell as? UserPostsTableViewCell else { return }
        
        userPostsTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("model[collectionView.tag].count: \(model[collectionView.tag].count)")
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if let userPostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionCell", for: indexPath) as? UserPostsCollectionViewCell{
            cell = userPostsCollectionCell
        }
        
        return cell
    }
}
