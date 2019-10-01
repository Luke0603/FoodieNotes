//
//  CommentTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/28.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentUserImgView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
