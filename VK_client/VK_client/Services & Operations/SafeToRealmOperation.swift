//
//  SafeToRealmOperation.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.08.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation
import RealmSwift

class SafeToRealmOperation: Operation {
    
    var users = [User]()
    
    override func main() {
        guard let parseDataOperation = dependencies.first as? ParseDataOperation else { return }
        users = parseDataOperation.outputData
        do {
            let realm = try Realm()
            let oldUsers = realm.objects(User.self)
            realm.beginWrite()
            realm.delete(oldUsers)
            realm.add(users)
            try realm.commitWrite()
        }
        catch {
            print("error while writing")
        }
    }
    
}
