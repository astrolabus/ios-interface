//
//  myGroupsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    private let searchController: UISearchController = .init()
    
    let vkClientServer = VKClientServer()
    
    private var myGroups = [Group]()
    private var mySearchedGroups = [Group]()
    var groupArray: [Group] {
        return Array(searchController.isActive ? mySearchedGroups : myGroups)
    }
    
    private var cachedPhotos = [String: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        vkClientServer.loadUserGroups() { groups in
            self.myGroups = groups
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsCell
        
        cell.groupName.text = groupArray[indexPath.row].name
        
        let url = groupArray[indexPath.row].photo_100
        
        if let cached = cachedPhotos[url] {
            cell.myGroupImageView.image = cached
        } else {
            downloadPhoto(for: url, indexPath: indexPath)
        }
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()

        return cell
    }
    
    //MARK: - Adding new groups
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let globalGroupsController = segue.source as? GlobalGroupsController else { return }
            
            if let indexPath = globalGroupsController.tableView.indexPathForSelectedRow {
                let group = globalGroupsController.groups[indexPath.row]
                
                myGroups.append(group)
                tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - SearchBar

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        mySearchedGroups = myGroups.filter( {$0.name.range(of: text, options: .caseInsensitive) != nil} )
        tableView.reloadData()
    }
}
