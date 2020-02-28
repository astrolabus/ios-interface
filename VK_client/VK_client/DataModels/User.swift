//
//  FriendsDataModel.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

struct User {
    var userName: String
    var userIcon: UIImage
    var userImages: [UIImage] = []
    
    func getSurname() -> String {
        let nameArr = userName.components(separatedBy: " ")
        return nameArr[1]
    }
}


