//
//  myGroupsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var myGroupsSearchBar: UISearchBar!
    
    let vkClientServer = VKClientServer()
    
    var myGroups = [Group]()
    
    var isSearching = false
    var mySearchedGroups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        myGroupsSearchBar.delegate = self
        
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
        if isSearching {
            return mySearchedGroups.count
        } else {
            return myGroups.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsCell
        
        if isSearching {
            cell.groupName.text = mySearchedGroups[indexPath.row].name
            cell.myGroupImageView.image  = vkClientServer.getPhotoByURL(url: mySearchedGroups[indexPath.row].photo_100)
        } else {
            cell.groupName.text = myGroups[indexPath.row].name
            cell.myGroupImageView.image = vkClientServer.getPhotoByURL(url: myGroups[indexPath.row].photo_100)
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

extension MyGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if myGroupsSearchBar.text == nil || myGroupsSearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            mySearchedGroups = myGroups.filter( {$0.name.range(of: myGroupsSearchBar.text!, options: .caseInsensitive) != nil} )
            tableView.reloadData()
        }
    }
}
