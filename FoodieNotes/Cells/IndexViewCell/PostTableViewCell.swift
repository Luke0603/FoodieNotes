//
//  PostTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/8/26.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var stroeNameLB: UILabel!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var likeCountLB: UILabel!
    @IBOutlet weak var messageCountLB: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var messageImg: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
