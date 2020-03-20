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
    var photos = [UIImage]()
    
    let vkClientServer = VKClientServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userNameTitle
        
        vkClientServer.loadUserPhotos()
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
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotosCell
    
        let photo = photos[indexPath.row]
        cell.userPhoto.image = photo
        
        return cell
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
