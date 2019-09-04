//
//  UserProfileViewController.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GoogleMaps

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let model = generateRandomData()
    
    @IBOutlet weak var userTableView: UITableView!
    
    @IBOutlet weak var storeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.estimatedRowHeight = 200
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.contentInsetAdjustmentBehavior = .never
        userTableView.isHidden = false
        print("userTableView.isHidden: \(userTableView.isHidden)")
        
        storeTableView.delegate = self
        storeTableView.dataSource = self
        storeTableView.estimatedRowHeight = 200
        storeTableView.rowHeight = UITableView.automaticDimension
        storeTableView.contentInsetAdjustmentBehavior = .never
        storeTableView.isHidden = true
        print("storeTableView.isHidden: \(storeTableView.isHidden)")
        
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
        
        print("cellForRowAt!!!!")
        
        if !userTableView.isHidden {
            print("userTableView: Here!!!!!!!!!!")
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
                    
                    userPostsCell.frame = tableView.bounds
                    userPostsCell.layoutIfNeeded()
                    
                    cell = userPostsCell
                }
            }
        }
        
        if !storeTableView.isHidden {
            print("storeTableView: Here!!!!!!!!!!!")
            if indexPath.item == 0 {
                if let storeNameCell = userTableView.dequeueReusableCell(withIdentifier: "StoreNameTableCell") as? StoreNameTableViewCell {
                    
                    storeNameCell.storeNameLabel.text = "Luke Chen Store"
                    
                    cell = storeNameCell
                }
            } else if indexPath.item == 1 {
                if let storeFollowCell = userTableView.dequeueReusableCell(withIdentifier: "StoreFollowTableCell") as? StoreFollowTableViewCell {
                    
                    storeFollowCell.storeFansCountLabel.text = "10000"
                    storeFollowCell.storeFollowCountLabel.text = "20000"
                    
                    cell = storeFollowCell
                }
            } else if indexPath.item == 2 {
                if let storeSummaryCell = userTableView.dequeueReusableCell(withIdentifier: "StoreSummaryTableCell") as? StoreSummaryTableViewCell {
                    
                    storeSummaryCell.storeSummaryLabel.text = "hello everyone my name is XXX\n i like XXX\n i want be a XXX\n nice to meet you!!!!!!!!!!!!!!!!!!!!!"
                    
                    cell = storeSummaryCell
                }
            } else if indexPath.item == 3 {
                if let storeMapCell = storeTableView.dequeueReusableCell(withIdentifier: "StoreMapTableCell") as? StoreMapTableViewCell {
                    
                    let camera = GMSCameraPosition.camera(withLatitude: 23.963, longitude: 120.522, zoom: 12.0)
                    
                    storeMapCell.storeGoogleMapView.camera = camera
                    
                    cell = storeMapCell
                }
            } else {
                if let storePostsCell = userTableView.dequeueReusableCell(withIdentifier: "StorePostsTableCell") as? StorePostsTableViewCell {
                    
                    cell = storePostsCell
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("forRowAt!!!!")
        if !userTableView.isHidden {
            
            guard let userPostsTableViewCell = cell as? UserPostsTableViewCell else { return }
            
            let cGSize = userPostsTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            userTableView.frame = CGRect(x:0, y:0, width: userTableView.frame.width, height: userTableView.frame.height +  cGSize.height)
            
        }
        
        if !storeTableView.isHidden {
            
            guard let storePostsTableViewCell = cell as? StorePostsTableViewCell else { return }
            
            let cGSize = storePostsTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            storeTableView.frame = CGRect(x:0, y:0, width: storeTableView.frame.width, height: storeTableView.frame.height +  cGSize.height)
            
        }
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("model[collectionView.tag].count: \(model[collectionView.tag].count)")
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if !userTableView.isHidden {
            if let userPostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionCell", for: indexPath) as? UserPostsCollectionViewCell {
                cell = userPostsCollectionCell
            }
        }
        
        if !storeTableView.isHidden {
            if let storePostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorePostsCollectionCell", for: indexPath) as? StorePostsCollectionViewCell {
                cell = storePostsCollectionCell
            }
        }
        
        return cell
    }
}
