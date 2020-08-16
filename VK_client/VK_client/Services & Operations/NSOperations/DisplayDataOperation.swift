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

class DisplayGroupsDataOperation: Operation {
    
    var controller: MyGroupsController
    
    init(controller: MyGroupsController) {
        self.controller = controller
    }
    
    override func main() {
        guard let safeGroupsToRealmOperation = dependencies.first as? SafeGroupsToRealmOperation else { return }
        controller.array = safeGroupsToRealmOperation.groups
        controller.tableView.reloadData()
    }
    
}

class DisplayNewsDataOperation: Operation {
    
    var controller: NewsTableViewController
    
    init(controller: NewsTableViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let safeNewsToRealmOperation = dependencies.first as? SafeNewsToRealmOperation else { return }
        controller.array = safeNewsToRealmOperation.news
        controller.tableView.reloadData()
    }
    
}

class DisplayUserPhotosDataOperation: Operation {
    
    var controller: UserPhotosController
    
    init(controller: UserPhotosController) {
        self.controller = controller
    }
    
    override func main() {
        guard let safeUserPhotosDataOperation = dependencies.first as? SafeUserPhotosToRealmOperation else { return }
        controller.array = safeUserPhotosDataOperation.photos
        controller.collectionView.reloadData()
    }
    
}
