//
//  userPhotosController.swift
//  VK_client
//
//  Created by Полина Войтенко on 14.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class UserPhotosController: UICollectionViewController {
    
    var userNameTitle: String?
    var userID: Int?
    var photos: [Photo] = []
    
    let vkClientServer = VKClientServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userNameTitle

        
        guard let id = userID else { return }
        vkClientServer.loadUserPhotos(userID: id) { photos in
            self.photos = photos
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotosCell
        
        cell.userPhoto.image = vkClientServer.getPhotoByURL(url: photos[indexPath.row].url)
        
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
