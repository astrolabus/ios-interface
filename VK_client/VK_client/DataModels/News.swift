//
//  News.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift

class NewsPostType: Object {
    @objc dynamic var name = ""
    
    @objc dynamic var date = ""
    @objc dynamic var photo_100 = ""
    
    @objc dynamic var type = ""
    @objc dynamic var text = ""
    @objc dynamic var url = ""
}
