//
//  myFriendsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class MyFriendsController: UITableViewController {
    
    private let searchController: UISearchController = .init()
    
    let vkClientServer = VKClientServer()
    
    private let operationQueue = OperationQueue()
    
    private var users: Results<User>?
    var array: [User] = []
    
    private var searchedUsers: [User] = []
    var generalUsersArray: [User] {
        return Array( searchController.isActive ? searchedUsers : array )
    }
    
    private var cachedPhotos = [String: UIImage]()
    
    private var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        let url = "https://api.vk.com/method/friends.get"
        let apiKey = Session.shared.token
        
        let parameters: Parameters = [
            "order": "hints",
            "fields": "photo_100",
            "access_token": apiKey,
            "v": "5.103"
        ]
        
        let request = AF.request(url, method: .get, parameters: parameters)
        
        let fetchDataOperation = FetchDataOperation(request: request)
        let parseDataOperation = ParseDataOperation()
        let safeToRealmOperation = SafeToRealmOperation()
        let displayDataOperation = DisplayDataOperation(controller: self)
        
        parseDataOperation.addDependency(fetchDataOperation)
        safeToRealmOperation.addDependency(parseDataOperation)
        displayDataOperation.addDependency(safeToRealmOperation)
        
        operationQueue.addOperation(fetchDataOperation)
        operationQueue.addOperation(parseDataOperation)
        
        OperationQueue.main.addOperation(safeToRealmOperation)
        OperationQueue.main.addOperation(displayDataOperation)
        
        // vkClientServer.loadFriendsList()
        // pairTableAndRealm()
    }
    
    // func getFriends() {}
    
    func pairTableAndRealm() {
        do {
            let realm = try Realm()
            users = realm.objects(User.self)
            token = users?.observe{ (changes) in
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    
                    self.tableView.deleteRows(at: deletions.map( {IndexPath(row: $0, section: 0)} ), with: .none)
                    self.tableView.insertRows(at: insertions.map( {IndexPath(row: $0, section: 0)} ), with: .none)
                    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    
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
        return generalUsersArray.count
    }
    
    private let queue = DispatchQueue(label: "friend_download_photo_queue")
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsCell
        
        cell.friendName.text = generalUsersArray[indexPath.row].first_name + " " + generalUsersArray[indexPath.row].last_name
        let url = generalUsersArray[indexPath.row].photo_100
        
        if let cached = cachedPhotos[url] {
            cell.friendIconImageView.image = cached
        } else {
            downloadPhoto(for: url, indexPath: indexPath)
        }
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var userName: String = ""
                var userID = 0

                let destinationViewController = segue.destination as? UserPhotosController

                userID = generalUsersArray[indexPath.row].id
                destinationViewController?.userID = userID
                
                userName = generalUsersArray[indexPath.row].first_name + " " + generalUsersArray[indexPath.row].last_name
                destinationViewController?.userNameTitle = userName

            }
        }
    }
    
}

// MARK: - SearchBar

//extension MyFriendsController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if friendsSearchBar.text == nil || friendsSearchBar.text == "" {
//            isSeraching = false
//            view.endEditing(true)
//            tableView.reloadData()
//        } else {
//            isSeraching = true
//            searchedFriends = users.filter( {$0.first_name.range(of: friendsSearchBar.text!, options: .caseInsensitive) != nil} )
//            tableView.reloadData()
//        }
//    }
//}


// DO - end editing by tapping search button
extension MyFriendsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchedUsers = usersArray.filter( {($0.first_name + $0.last_name).range(of: text, options: .caseInsensitive) != nil} )
        tableView.reloadData()
    }
}

extension MyFriendsController {
    var usersArray: [User] {
        guard let users = users else { return [] }
        return Array(users)
    }
}
