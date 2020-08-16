//
//  NewsTableViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class NewsTableViewController: UITableViewController {
    
    let vkClientServer = VKClientServer()
    var photoService: PhotoService?
    
    private let operationQueue = OperationQueue()
    
    var array: [NewsPostType] = []
    
    private var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.vk.com/method//newsfeed.get"
        let apiKey = Session.shared.token
        
        let parameters: Parameters = [
            "access_token": apiKey,
            "v": "5.103",
            "filters": "post"
        ]
        
        let request = AF.request(url, method: .get, parameters: parameters)
        
        let fetchDataOperation = FetchDataOperation(request: request)
        let parseDataOperation = ParseNewsDataOperation()
        let safeToRealmOperation = SafeNewsToRealmOperation()
        let displayDataOperation = DisplayNewsDataOperation(controller: self)
        
        parseDataOperation.addDependency(fetchDataOperation)
        safeToRealmOperation.addDependency(parseDataOperation)
        displayDataOperation.addDependency(safeToRealmOperation)
        
        operationQueue.addOperation(fetchDataOperation)
        operationQueue.addOperation(parseDataOperation)
        
        OperationQueue.main.addOperation(safeToRealmOperation)
        OperationQueue.main.addOperation(displayDataOperation)
        
        photoService = PhotoService(container: tableView)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsPostCell", for: indexPath) as! NewsPostTableViewCell
            
        cell.userName.text = array[indexPath.row].name
        cell.postDate.text = array[indexPath.row].date
        cell.postContent.text = array[indexPath.row].text
        
        let userPhotoURL = array[indexPath.row].photo_100
        cell.userIcon.image = photoService?.photo(atIndexpath: indexPath, byUrl: userPhotoURL)
        
        let postPhotoURL = array[indexPath.row].url
        cell.postPhoto.image = photoService?.photo(atIndexpath: indexPath, byUrl: postPhotoURL)
        
//        if postPhotoURL == "" {
//            cell.photoHeight.constant = 0
//        }
        
        cell.shapeContainer.circle()
            
        return cell
    }

}
