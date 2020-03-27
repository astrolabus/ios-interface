//
//  GroupsDataModel.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift

class Group: Object {
    @objc dynamic var name = ""
    @objc dynamic var photo_100 = ""
}
