//
//  ChildViewShape.swift
//  VK_client
//
//  Created by Полина Войтенко on 18.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class ChildViewShape: UIView {

    func circle() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }

}
