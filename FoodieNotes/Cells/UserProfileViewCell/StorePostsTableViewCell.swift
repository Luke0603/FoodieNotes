//
//  StorePostsTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/3.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class StorePostsTableViewCell: UITableViewCell {

    @IBOutlet weak var storePostsCollectionView: UICollectionView!
    
    @IBOutlet weak var storePostsCollectionViewHigh: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StorePostsTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) -> CGSize{
        
        storePostsCollectionView.delegate = dataSourceDelegate
        storePostsCollectionView.dataSource = dataSourceDelegate
        storePostsCollectionView.tag = row
        storePostsCollectionView.setContentOffset(storePostsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        
        //更新collectionView的高度约束
        let contentSize = storePostsCollectionView.collectionViewLayout.collectionViewContentSize
        
        print("contentSize.height[1]: \(contentSize.height)")
        
        storePostsCollectionViewHigh.constant = contentSize.height
        
        storePostsCollectionView.collectionViewLayout.invalidateLayout()
        
        storePostsCollectionView.reloadData()
        
        return contentSize
    }
}
