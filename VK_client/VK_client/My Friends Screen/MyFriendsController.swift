//
//  myFriendsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {
    
    private let searchController: UISearchController = .init()
    
    let vkClientServer = VKClientServer()
    
    private var users: [User] = []
    private var searchedUsers : [User] = []
    var userArray: [User] {
        return Array( searchController.isActive ? searchedUsers : users )
    }
    
    private var cachedPhotos = [String: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        vkClientServer.loadFriendsList() { users in
            self.users = users
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    private func downloadPhoto(for url: String, indexPath: IndexPath) {
        DispatchQueue.global().async {
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
        
        cell.friendName.text = userArray[indexPath.row].first_name + " " + userArray[indexPath.row].last_name
        let url = userArray[indexPath.row].photo_100
        
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

                userID = userArray[indexPath.row].id
                destinationViewController?.userID = userID
                
                userName = userArray[indexPath.row].first_name + " " + userArray[indexPath.row].last_name
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
        searchedUsers = users.filter( {($0.first_name + $0.last_name).range(of: text, options: .caseInsensitive) != nil} )
        tableView.reloadData()
    }
}
