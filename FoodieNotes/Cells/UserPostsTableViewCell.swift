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
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        userPostsCollectionView.delegate = dataSourceDelegate
        userPostsCollectionView.dataSource = dataSourceDelegate
        userPostsCollectionView.tag = row
        userPostsCollectionView.setContentOffset(userPostsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        userPostsCollectionView.reloadData()
    }
}