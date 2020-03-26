//
//  myFriendsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {
    
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    let vkClientServer = VKClientServer()
    
    var users: [User] = []
    
    var searchedFriends: [User] = []
    var isSeraching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsSearchBar.delegate = self
        
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
        if isSeraching {
            return searchedFriends.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsCell
        
        if isSeraching {
            cell.friendName.text = searchedFriends[indexPath.row].first_name + " " + searchedFriends[indexPath.row].last_name
            cell.friendIconImageView.image = vkClientServer.getPhotoByURL(url: searchedFriends[indexPath.row].photo_100)
        } else {
            cell.friendName.text = users[indexPath.row].first_name + " " + users[indexPath.row].last_name
            cell.friendIconImageView.image = vkClientServer.getPhotoByURL(url: users[indexPath.row].photo_100)
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

                if isSeraching {
                    userID = searchedFriends[indexPath.row].id
                    destinationViewController?.userID = userID
                    
                    userName = searchedFriends[indexPath.row].first_name
                    destinationViewController?.userNameTitle = userName

                } else {
                    userID = users[indexPath.row].id
                    destinationViewController?.userID = userID
                    
                    userName = users[indexPath.row].first_name + " " + users[indexPath.row].last_name
                    destinationViewController?.userNameTitle = userName
                }

            }
        }
    }
    
}

// MARK: - SearchBar

extension MyFriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if friendsSearchBar.text == nil || friendsSearchBar.text == "" {
            isSeraching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSeraching = true
            searchedFriends = users.filter( {$0.first_name.range(of: friendsSearchBar.text!, options: .caseInsensitive) != nil} )
            tableView.reloadData()
        }
    }
}
