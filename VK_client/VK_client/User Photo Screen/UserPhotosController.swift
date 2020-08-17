//
//  userPhotosController.swift
//  VK_client
//
//  Created by Полина Войтенко on 14.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class UserPhotosController: UICollectionViewController {
    
    var userNameTitle: String?
    var userID: Int?
    var photos: Results<Photo>?
    
    var array: [Photo] = []
    
    private let operationQueue = OperationQueue()
    
    let vkClientServer = VKClientServer()
    var photoService: PhotoService?
    
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userNameTitle
        
        let baseURL = "https://api.vk.com/method/photos.getAll"
        let apiKey = Session.shared.token
        
        guard let id = userID else { return }
        
        let parameters: Parameters = [
            "owner_id": id,
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let request = AF.request(baseURL, method: .get, parameters: parameters)
        
        let fetchDataOperation = FetchDataOperation(request: request)
        let parseDataOperation = ParseUserPhotosDataOperation()
        let safeToRealmOperation = SafeUserPhotosToRealmOperation(user: id)
        let displayDataOperation = DisplayUserPhotosDataOperation(controller: self)
        
        parseDataOperation.addDependency(fetchDataOperation)
        safeToRealmOperation.addDependency(parseDataOperation)
        displayDataOperation.addDependency(safeToRealmOperation)
        
        operationQueue.addOperation(fetchDataOperation)
        operationQueue.addOperation(parseDataOperation)
        
        OperationQueue.main.addOperation(safeToRealmOperation)
        OperationQueue.main.addOperation(displayDataOperation)
        
        photoService = PhotoService(container: collectionView)
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotosCell
        
        cell.userPhoto.image = photoService?.photo(atIndexpath: indexPath, byUrl: array[indexPath.row].url)
                
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goImage" {
            let selectedCell = sender as? UserPhotosCell
            let photo = selectedCell?.userPhoto.image
            
            let destinationViewController = segue.destination as? ShowImageViewController
            
            destinationViewController?.currentPhoto = photo
        }
    }

}
