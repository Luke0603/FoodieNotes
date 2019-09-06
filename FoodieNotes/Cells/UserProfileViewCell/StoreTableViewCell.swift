//
//  StoreTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/5.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit
import GoogleMaps

class StoreTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var storeFansCountLabel: UILabel!
    
    @IBOutlet weak var storeFollowCountLabel: UILabel!
    
    @IBOutlet weak var storeSummaryLabel: UILabel!
    
    @IBOutlet weak var storePriceLabel: UILabel!
    
    @IBOutlet weak var storeMapView: GMSMapView!
    
    @IBOutlet weak var storeImg: UIImageView!
    
    @IBOutlet weak var storePostsCollectionView: UICollectionView!
    
    @IBOutlet weak var storePostsCollectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storePostsCollectionView.delegate = self
        storePostsCollectionView.dataSource = self
        storePostsCollectionView.register(UINib(nibName:"UserPostsCollectionViewCell", bundle:nil),forCellWithReuseIdentifier: "UserPostsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData() {
        
        //collectionView重新加载
        storePostsCollectionView.reloadData()
        
        //更新collectionView的高度约束
        let contentSize = storePostsCollectionView.collectionViewLayout.collectionViewContentSize
        
        storePostsCollectionViewHeight.constant = contentSize.height
        
        storePostsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if let userPostsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCollectionViewCell", for: indexPath) as? UserPostsCollectionViewCell {
            cell = userPostsCollectionCell
        }
        
        return cell
    }
}
