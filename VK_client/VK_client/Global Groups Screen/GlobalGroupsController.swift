//
//  globalGroupsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class GlobalGroupsController: UITableViewController {
    
    private let searchController: UISearchController = .init()
        
    var groups: [Group] = []
    var searchedGroups = [Group]()
    var groupArray: [Group] {
        return Array( searchController.isActive ? searchedGroups : groups )
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalCell", for: indexPath) as! GlobalsGroupsCell
        
        cell.globalGroupName.text = groupArray[indexPath.row].name
        cell.globalGroupImageView.image = UIImage(named: "rian")
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()

        return cell
    }
}

// MARK: - SearchBar

extension GlobalGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchedGroups = groups.filter( {$0.name.range(of: text, options:  .caseInsensitive) != nil} )
        tableView.reloadData()
    }
}
