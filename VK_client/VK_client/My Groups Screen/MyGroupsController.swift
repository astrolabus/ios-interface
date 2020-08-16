//
//  myGroupsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import PromiseKit

class MyGroupsController: UITableViewController {
    
    private let searchController: UISearchController = .init()
    
    let vkClientServer = VKClientServer()
    let getDataPromises = GetDataPromises()
    
    private let operationQueue = OperationQueue()
    
    private var myGroups: Results<Group>?
    
    var array: [Group] = []
    private var mySearchedGroups: [Group] = []
    var myGroupGeneralArray: [Group] {
        return Array(searchController.isActive ? mySearchedGroups : myGroupsArray)
    }
    
    private var cachedPhotos = [String: UIImage]()
    
    private var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        loadingGroupsData()
        pairTableAndRealm()
    }
    
    func loadingGroupsData() {
        firstly {
            getDataPromises.fetchGroupsData()
        }.then { data in
            self.getDataPromises.parseGroupData(data: data)
        }.then { groups in
            self.getDataPromises.saveGroupDataToRealm(groups)
        }.catch { _ in
            print("shit happend")
        }
    }
    
    func pairTableAndRealm() {
        do {
            let realm = try Realm()
            myGroups = realm.objects(Group.self)
            token = myGroups?.observe{ (changes) in
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
        return myGroupGeneralArray.count
    }
    
    private let queue = DispatchQueue(label: "my_groups_download_photo_queue")
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsCell
        
        cell.groupName.text = myGroupGeneralArray[indexPath.row].name
        
        let url = myGroupGeneralArray[indexPath.row].photo_100
        
        if let cached = cachedPhotos[url] {
            cell.myGroupImageView.image = cached
        } else {
            downloadPhoto(for: url, indexPath: indexPath)
        }
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let group = myGroups?[indexPath.row] else {return}
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - SearchBar

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        mySearchedGroups = myGroupsArray.filter( {$0.name.range(of: text, options: .caseInsensitive) != nil} )
        tableView.reloadData()
    }
}

extension MyGroupsController {
    var myGroupsArray: [Group] {
        guard let groups = myGroups else { return [] }
        return Array(groups)
    }
}
