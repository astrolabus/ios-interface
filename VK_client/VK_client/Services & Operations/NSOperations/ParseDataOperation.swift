//
//  ParceDataOperation.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.08.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParseDataOperation: Operation {
    
    var outputData: [User] = []
    
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation, let data = fetchDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                let users = User()
                users.id = item["id"].intValue
                users.first_name = item["first_name"].stringValue
                users.last_name = item["last_name"].stringValue
                users.photo_100 = item["photo_100"].stringValue

                return users
            }
            
            outputData = result
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

class ParseGroupsDataOperation: Operation {
    
    var outputData: [Group] = []
    
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation, let data = fetchDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Group in
                let groups = Group()
                groups.name = item["name"].stringValue
                groups.photo_100 = item["photo_100"].stringValue
                
                return groups
            }
            
            outputData = result
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

class ParseNewsDataOperation: Operation {
    
    var outputData: [NewsPostType] = []
    
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation, let data = fetchDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            let groupsArray = json["response"]["groups"].arrayValue
            
            let result = array.map{ item -> NewsPostType in
                let news = NewsPostType()
                
                var name = ""
                var photo_100 = ""
                var photo_url = ""
                
                for i in 0..<groupsArray.count {
                    if (item["source_id"].intValue * (-1)) == groupsArray[i]["id"].intValue {
                        name = groupsArray[i]["name"].stringValue
                        photo_100 = groupsArray[i]["photo_100"].stringValue
                    }
                }
                
                news.type = item["post_type"].stringValue
                news.date = item["date"].stringValue
                news.text = item["text"].stringValue
                
                if item["attachments"][0]["type"].stringValue == "photo" {
                    photo_url = item["attachments"][0]["photo"]["sizes"][0]["url"].stringValue
                } else if item["attachments"][0]["type"].stringValue == "link" {
                    photo_url = item["attachments"][0]["link"]["photo"]["sizes"][0]["url"].stringValue
                } else {
                    photo_url = ""
                }
                
                news.name = name
                news.photo_100 = photo_100
                news.url = photo_url
                
                return news
            }
            
            outputData = result
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

class ParseUserPhotosDataOperation: Operation {
    
    var outputData: [Photo] = []
    
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation, let data = fetchDataOperation.data else { return }
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photo in
                let photos = Photo()
                photos.id = item["id"].intValue
                photos.owner_id = item["owner_id"].intValue
                
                let sizes = item["sizes"].arrayValue
                if let first = sizes.first {
                    photos.url = first["url"].stringValue
                }
                
                return photos
            }
            
            outputData = result
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
