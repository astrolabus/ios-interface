//
//  Session.swift
//  VK_client
//
//  Created by Полина Войтенко on 13.03.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//
import UIKit

class Session {
    static let shared: Session = .init()
    
    private init() {}
    
    var token = ""
    var userID = ""
}
