//
//  News.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

enum PostType {
    case photo
    case post
}

struct NewsPost {
    var userIcon: UIImage?
    var userName: String
    var postDate: String
    
    var postContent: String
    var postImage: UIImage?
    
    var postType: PostType
}
