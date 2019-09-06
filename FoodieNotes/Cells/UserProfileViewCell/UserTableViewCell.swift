//
//  UserTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/5.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userFansCountLabel: UILabel!
    
    @IBOutlet weak var userFollowCountLabel: UILabel!
    
    @IBOutlet weak var userSummaryLabel: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userPostsCollectionView: UICollectionView!
    
    @IBOutlet weak var userPostsCollectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userPostsCollectionView.delegate = self
        userPostsCollectionView.dataSource = self
        userPostsCollectionView.register(UINib(nibName:"UserPostsCollectionViewCell", bundle:nil),forCellWithReuseIdentifier: "UserPostsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData() {
        
        //collectionView重新加载
        userPostsCollectionView.reloadData()
        
        //更新collectionView的高度约束
        let contentSize = userPostsCollectionView.collectionViewLayout.collectionViewContentSize
        
        userPostsCollectionViewHeight.constant = contentSize.height
        
        userPostsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 90
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if let userPostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionViewCell", for: indexPath) as? UserPostsCollectionViewCell {
            cell = userPostsCollectionCell
        }
        
        return cell
    }
    
}

//extension UserTableViewCell {
//
//    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
//
//        userPostsCollectionView.delegate = dataSourceDelegate
//        userPostsCollectionView.dataSource = dataSourceDelegate
//        userPostsCollectionView.register(UINib(nibName:"UserPostsCollectionViewCell", bundle:nil),forCellWithReuseIdentifier: "UserPostsCollectionViewCell")
//        userPostsCollectionView.tag = row
//        userPostsCollectionView.setContentOffset(userPostsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
//        userPostsCollectionView.reloadData()
//        //更新collectionView的高度约束
//        let contentSize = userPostsCollectionView.collectionViewLayout.collectionViewContentSize
//
//        print("contentSize.height[1]: \(contentSize.height)")
//
//        userPostsCollectionViewHeight.constant = contentSize.height
//
//        userPostsCollectionView.collectionViewLayout.invalidateLayout()
//
//
//    }
//}
