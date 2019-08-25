//
//  IndexTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/26.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class LiveTableViewCell: UITableViewCell {

    @IBOutlet weak var liveCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LiveTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        liveCollectionView.delegate = dataSourceDelegate
        liveCollectionView.dataSource = dataSourceDelegate
        liveCollectionView.tag = row
        liveCollectionView.setContentOffset(liveCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        liveCollectionView.reloadData()
    }
}
