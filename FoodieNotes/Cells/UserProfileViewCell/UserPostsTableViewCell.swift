//
//  UserPostsTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class UserPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPostsCollectionView: UICollectionView!
    
    @IBOutlet weak var userPostsCollectionViewHigh: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension UserPostsTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) -> CGSize{
        
        userPostsCollectionView.delegate = dataSourceDelegate
        userPostsCollectionView.dataSource = dataSourceDelegate
        userPostsCollectionView.tag = row
        userPostsCollectionView.setContentOffset(userPostsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        
        //更新collectionView的高度约束
        let contentSize = userPostsCollectionView.collectionViewLayout.collectionViewContentSize
        
        print("contentSize.height[1]: \(contentSize.height)")
        
        userPostsCollectionViewHigh.constant = contentSize.height
        
        userPostsCollectionView.collectionViewLayout.invalidateLayout()
        
        userPostsCollectionView.reloadData()
        
        return contentSize
    }
}
