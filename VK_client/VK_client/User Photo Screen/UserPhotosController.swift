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
    var photos: Results<Photo>?
    
    var cachedPhotos = [String: UIImage]()
    
    let vkClientServer = VKClientServer()
    
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = userNameTitle

        
        guard let id = userID else { return }
        vkClientServer.loadUserPhotos(userID: id)
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        do {
            let realm = try Realm()
            photos = realm.objects(Photo.self)
            token = photos?.observe{ (changes) in
                switch changes {
                case .initial:
                    self.collectionView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                        self.collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                        self.collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                    }, completion: nil)

                case .error(let error):
                    print(error.localizedDescription)
                }
            }
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
        return photos?.count ?? 0
    }
    
    private let queue = DispatchQueue(label: "user_photos_download_queue")
    
    private func downloadPhoto(for url: String, indexPath: IndexPath) {
        queue.async {
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
        
        let url = photos?[indexPath.row].url ?? ""
        
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
