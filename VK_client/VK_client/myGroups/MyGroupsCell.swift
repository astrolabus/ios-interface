//
//  myGroupsCell.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var myGroupImageView: UIImageView!
    @IBOutlet weak var childContainerView: ChildViewShape!
    @IBOutlet weak var parentContainerView: ParentViewShadow!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
