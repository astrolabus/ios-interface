//
//  Promises.swift
//  VK_client
//
//  Created by Полина Войтенко on 15.08.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import PromiseKit

class GetDataPromises {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func fetchGroupsData() -> Promise<Data> {
        return Promise { seal in
            
            let path = "/groups.get"
            
            let parameters: Parameters = [
                "extended": 1,
                "access_token": apiKey,
                "v": "5.103"
            ]
            
            let url = baseURL + path
            
            AF.request(url, method: .get, parameters: parameters).responseJSON { response in
                
                guard let data = response.data else {
                    let error = response.error
                    seal.reject(error!)
                    return
                }
                seal.fulfill(data)
                
            }
        }
    }
    
    func parseGroupData(data: Data) -> Promise<[Group]> {
        return Promise { seal in
            do {
                let json = try JSON(data: data)
                let array = json["response"]["items"].arrayValue
                       
                let result = array.map { item -> Group in
                    let group = Group()
                    group.name = item["name"].stringValue
                    group.photo_100 = item["photo_100"].stringValue
                           
                    return group
                }
                seal.fulfill(result)
                       
            } catch {
                seal.reject(error)
            }
        }
    }
    
    func saveGroupDataToRealm(_ groups: [Group]) -> Promise<[Group]> {
        return Promise { seal in
            do {
                let realm = try Realm()
                let oldGroups = realm.objects(Group.self)
                realm.beginWrite()
                realm.delete(oldGroups)
                realm.add(groups)
                try realm.commitWrite()
                
                seal.fulfill(groups)
            }
            catch {
                seal.reject(error)
            }
        }
    }
    
}
