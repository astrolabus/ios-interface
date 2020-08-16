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

class SafeGroupsToRealmOperation: Operation {
    
    var groups = [Group]()
    
    override func main() {
        guard let parseGroupsDataOperation = dependencies.first as? ParseGroupsDataOperation else { return }
        groups = parseGroupsDataOperation.outputData
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups)
            try realm.commitWrite()
        }
        catch {
            print("error while writing")
        }
    }
    
}

class SafeNewsToRealmOperation: Operation {
    
    var news = [NewsPostType]()
    
    override func main() {
        guard let parseNewsDataOperation = dependencies.first as? ParseNewsDataOperation else { return }
        news = parseNewsDataOperation.outputData
        do {
            let realm = try Realm()
            let oldNews = realm.objects(NewsPostType.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.add(news)
            try realm.commitWrite()
        }
        catch {
            print("error while writing")
        }
    }
    
}

class SafeUserPhotosToRealmOperation: Operation {

    
    var photos = [Photo]()
    var user = 0
    
    init(user: Int) {
        self.user = user
    }
    
    override func main() {
        guard let parseUserPhotosDataOperation = dependencies.first as? ParseUserPhotosDataOperation else { return }
        photos = parseUserPhotosDataOperation.outputData
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(Photo.self)
            realm.beginWrite()
            realm.delete(oldPhotos)
            
            photos.forEach{ $0.owner_id = user }
            
            realm.add(photos)
            try realm.commitWrite()
        }
        catch {
            print("error while writing")
        }
    }
    
}
