//
//  globalGroupsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class GlobalGroupsController: UITableViewController {
    
    @IBOutlet weak var globalGroupsSearchBar: UISearchBar!
    
    
    var groups = [
        Group(groupName: "Star Wars Explained", groupImage: UIImage(named: "sw-explained")),
        Group(groupName: "Clone Wars Explained", groupImage: UIImage(named: "clone-wars-logo")),
        Group(groupName: "Rebels Explained", groupImage: UIImage(named: "rebels-logo")),
        Group(groupName: "Star Wars", groupImage: UIImage(named: "sw-logo")),
        Group(groupName: "Clone Wars", groupImage: UIImage(named: "clone-wars")),
        Group(groupName: "Rebels", groupImage: UIImage(named: "rebels"))
    ]
    
    var isSearching = false
    var searchedGroups = [Group]()
    
    let vkClientServer = VKClientServer()

    override func viewDidLoad() {
        super.viewDidLoad()
        globalGroupsSearchBar.delegate = self
        
        vkClientServer.loadSearchedGroups(groupName: "twit")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedGroups.count
        } else {
            return groups.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalCell", for: indexPath) as! GlobalsGroupsCell
        
        if isSearching {
            cell.globalGroupName.text = searchedGroups[indexPath.row].groupName
            cell.globalGroupImageView.image = searchedGroups[indexPath.row].groupImage
        } else {
            cell.globalGroupName.text = groups[indexPath.row].groupName
            cell.globalGroupImageView.image = groups[indexPath.row].groupImage
        }
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()

        return cell
    }
}

// MARK: - SearchBar

extension GlobalGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if globalGroupsSearchBar.text == nil || globalGroupsSearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            searchedGroups = groups.filter( {$0.groupName.range(of: globalGroupsSearchBar.text!, options: .caseInsensitive) != nil} )
            tableView.reloadData()
        }
    }
}
