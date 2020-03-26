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
    
    
    var groups: [Group] = []
    
    var isSearching = false
    var searchedGroups = [Group]()


    override func viewDidLoad() {
        super.viewDidLoad()
        globalGroupsSearchBar.delegate = self
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
            cell.globalGroupName.text = searchedGroups[indexPath.row].name
            cell.globalGroupImageView.image = UIImage(named: "rian")
        } else {
            cell.globalGroupName.text = groups[indexPath.row].name
            cell.globalGroupImageView.image = UIImage(named: "rian")
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
            searchedGroups = groups.filter( {$0.name.range(of: globalGroupsSearchBar.text!, options: .caseInsensitive) != nil} )
            tableView.reloadData()
        }
    }
}
