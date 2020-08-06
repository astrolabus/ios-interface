//
//  NewsPostTableViewCell.swift
//  VK_client
//
//  Created by Полина Войтенко on 28.07.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class NewsPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shapeContainer: ShapeContainer!
    
    @IBOutlet weak var postContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
