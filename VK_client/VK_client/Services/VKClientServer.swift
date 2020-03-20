//
//  VKClientServer.swift
//  VK_client
//
//  Created by Полина Войтенко on 17.03.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import Foundation
import Alamofire

class VKClientServer {
    
    let baseURL = "https://api.vk.com/method"
    let apiKey = Session.shared.token
    
    //methods
    
    func loadFriendsList() {
        
        let path = "/friends.get"
        
        let parameters: Parameters = [
            "order": "hints",
            "fields": "bdate",
            "access_token": apiKey,
            "count": 5,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value)
        }
        
    }
    
    func loadUserPhotos() {
        
        let path = "/photos.getAll"
        
        let parameters: Parameters = [
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value)
        }
        
    }
    
    func loadUserGroups() {
        
        let path = "/groups.get"
        
        let parameters: Parameters = [
            "extended": 1,
            "count": 5,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value)
        }
        
    }
    
    func loadSearchedGroups(groupName: String) {
        
        let path = "/groups.search"
        
        let parameters: Parameters = [
            "q": groupName,
            "count": 5,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let url = baseURL + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value)
        }
        
    }
    
    func removeCookies() {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}
