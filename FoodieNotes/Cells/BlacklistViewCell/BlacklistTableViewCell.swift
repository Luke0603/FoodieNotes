//
//  BlacklistTableViewCell.swift
//  FoodieNotes
//
//  Created by 陳博竣 on 2019/9/10.
//  Copyright © 2019 Luke. All rights reserved.
//

import UIKit

class BlacklistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var blacklistUserImg: UIImageView!
    
    @IBOutlet weak var blacklistUserName: UILabel!
    
    @IBOutlet weak var blacklistRemoveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
