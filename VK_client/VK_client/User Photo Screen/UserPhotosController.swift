//
//  userPhotosController.swift
//  VK_client
//
//  Created by Полина Войтенко on 14.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift

class UserPhotosController: UICollectionViewController {
    
    var userNameTitle: String?
    var userID: Int?
    var photos: [Photo] = []
    
    var cachedPhotos = [String: UIImage]()
    
    let vkClientServer = VKClientServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userNameTitle

        
        guard let id = userID else { return }
        vkClientServer.loadUserPhotos(userID: id) { [weak self] in
            self?.loadData()
            self?.collectionView.reloadData()
        }
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let photos = realm.objects(Photo.self).filter("owner_id = %@", userID!)
            self.photos = Array(photos)
        }
        catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    private func downloadPhoto(for url: String, indexPath: IndexPath) {
        DispatchQueue.global().async {
            if let photo = self.vkClientServer.getPhotoByURL(url: url) {
                self.cachedPhotos[url] = photo
                
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotosCell
        
        let url = photos[indexPath.row].url
        
        if let cached = cachedPhotos[url] {
            cell.userPhoto.image = cached
        } else {
            downloadPhoto(for: url, indexPath: indexPath)
        }
                
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
