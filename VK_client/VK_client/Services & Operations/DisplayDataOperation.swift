//
//  DisplayDataOperation.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.08.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation

class DisplayDataOperation: Operation {
    
    var controller: MyFriendsController
    
    init(controller: MyFriendsController) {
        self.controller = controller
    }
    
    override func main() {
        guard let safeToRealmOperation = dependencies.first as? SafeToRealmOperation else { return }
        controller.array = safeToRealmOperation.users
        controller.tableView.reloadData()
    }
    
}
