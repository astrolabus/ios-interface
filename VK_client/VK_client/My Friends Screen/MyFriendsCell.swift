//
//  myFriendsCell.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendIconImageView: UIImageView!
    @IBOutlet weak var childContainerView: ShapeContainer!
    @IBOutlet weak var parentContainerView: ShadowContainer!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
