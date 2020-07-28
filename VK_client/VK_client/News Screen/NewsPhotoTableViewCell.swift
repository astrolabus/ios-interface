//
//  NewsPhotoTableViewCell.swift
//  VK_client
//
//  Created by Полина Войтенко on 28.07.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class NewsPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var shapeContainer: ShapeContainer!
    
    @IBOutlet weak var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
