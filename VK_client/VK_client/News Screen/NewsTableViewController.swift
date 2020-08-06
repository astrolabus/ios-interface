//
//  NewsTableViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {
    
    let vkClientServer = VKClientServer()
    
    private var news: Results<NewsPostType>?
    
    private var token: NotificationToken?
    
    private var cachedPhotos = [String: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkClientServer.loadNewsFeed()
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        do {
            let realm = try Realm()
            news = realm.objects(NewsPostType.self)
            token = news?.observe{ (changes) in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    
                    self.tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .none)
                    self.tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .none)
                    self.tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .none)
                    
                    self.tableView.endUpdates()
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    private let queue = DispatchQueue(label: "news_download_photo_queue")

    private func downloadPhoto(for url: String, indexPath: IndexPath) {
        queue.async {
            if let photo = self.vkClientServer.getPhotoByURL(url: url) {
                self.cachedPhotos[url] = photo
                
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsPostCell", for: indexPath) as! NewsPostTableViewCell
            
        cell.userName.text = news?[indexPath.row].name
        cell.postDate.text = news?[indexPath.row].date
        cell.postContent.text = news?[indexPath.row].text
        
        let userPhotoURL = news?[indexPath.row].photo_100 ?? ""
        
        if let cached = cachedPhotos[userPhotoURL] {
            cell.userIcon.image = cached
        } else {
            downloadPhoto(for: userPhotoURL, indexPath: indexPath)
        }
        
        let postPhotoURL = news?[indexPath.row].url ?? ""
        
        if let cachedPhoto = cachedPhotos[postPhotoURL] {
            cell.postPhoto.image = cachedPhoto
        } else {
            downloadPhoto(for: postPhotoURL, indexPath: indexPath)
        }
        
//        if postPhotoURL == "" {
//            cell.photoHeight.constant = 0
//        }
        
        cell.shapeContainer.circle()
            
        return cell
    }

}
