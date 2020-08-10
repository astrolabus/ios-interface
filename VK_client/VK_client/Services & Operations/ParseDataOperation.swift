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
