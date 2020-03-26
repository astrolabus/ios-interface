//
//  VKClientServer.swift
//  VK_client
//
//  Created by Полина Войтенко on 17.03.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKClientServer {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    func loadFriendsList(_ completion: @escaping ([User]) -> Void ) {
        
        let path = "/friends.get"
        
        let parameters: Parameters = [
            "order": "hints",
            "fields": "photo_100",
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let error = response.error {
                print(error)
            }
            else {
                guard let data = response.data else { return }

                let users: [User] = self.parseUsers(data: data)

                completion(users)
            }
        }
    }
    
    func loadUserPhotos(userID: Int, _ completion: @escaping ([Photo]) -> Void) {
        
        let path = "/photos.getAll"
        
        let parameters: Parameters = [
            "owner_id": userID,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let error = response.error {
                print(error)
            }
            else {
                guard let data = response.data else { return }

                let photos: [Photo] = self.parsePhotos(data: data)

                completion(photos)
            }
        }
        
    }
    
    func loadUserGroups(_ completion: @escaping ([Group]) -> Void) {
        
        let path = "/groups.get"
        
        let parameters: Parameters = [
            "extended": 1,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            if let error = response.error {
                print(error)
            }
            else {
                guard let data = response.data else { return }

                let groups: [Group] = self.parseGroups(data: data)

                completion(groups)
            }
        }
        
    }
    
    func loadSearchedGroups(groupName: String, _ completion: @escaping ([User]) -> Void) {
        
        let path = "/groups.search"
        
        let parameters: Parameters = [
            "q": groupName,
            "count": 5,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value!)
        }
        
    }
    
    func removeCookies() {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}

extension VKClientServer {
    
    func parseUsers(data: Data) -> [User] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                var users = User()
                users.id = item["id"].intValue
                users.first_name = item["first_name"].stringValue
                users.last_name = item["last_name"].stringValue
                users.photo_100 = item["photo_100"].stringValue

                return users
            }
            
            print("groups returned")
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parseGroups(data: Data) -> [Group] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
                   
            let result = array.map { item -> Group in
                var group = Group()
                group.name = item["name"].stringValue
                group.photo_100 = item["photo_100"].stringValue
                       
                return group
            }
                   
            return result
                   
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func parsePhotos(data: Data) -> [Photo] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photo in
                var photos = Photo()
                photos.id = item["id"].intValue
                photos.owner_id = item["owner_id"].intValue
                
                let sizes = item["sizes"].arrayValue
                if let first = sizes.first {
                    photos.url = first["url"].stringValue
                }
                
                return photos
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}

extension VKClientServer {
    func getPhotoByURL(url: String) -> UIImage? {
        guard let photoURL = URL(string: url) else { return nil }
        
        if let photoData: Data = try? Data(contentsOf: photoURL) {
            return UIImage(data: photoData)
        }
        
        return nil
    }
}
