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
    
    var friends: [User] = [
        User(userName: "Anakin Skywalker",
             userIcon: UIImage(named: "anakin")!,
             userImages: [UIImage(named: "oscars")!, UIImage(named: "padme")!]),
        User(userName: "Ashoka Tano",
             userIcon: UIImage(named: "ashoka")!,
             userImages: [UIImage(named: "mando")!, UIImage(named: "rex")!]),
        User(userName: "Padme Amidala",
             userIcon: UIImage(named: "padme")!,
             userImages: [UIImage(named: "rian")!, UIImage(named: "anakin")!]),
        User(userName: "Din Djarin",
             userIcon: UIImage(named: "din")!,
             userImages: [UIImage(named: "oscars")!, UIImage(named: "mando")!]),
        User(userName: "Leia Organa",
             userIcon: UIImage(named: "leia")!,
             userImages: [UIImage(named: "mando")!, UIImage(named: "han")!]),
        User(userName: "Ezra Bridger",
             userIcon: UIImage(named: "ezra")!,
             userImages: [UIImage(named: "rian")!, UIImage(named: "mando")!]),
        User(userName: "Han Solo",
             userIcon: UIImage(named: "han")!,
             userImages: [UIImage(named: "oscars")!, UIImage(named: "leia")!]),
        User(userName: "Rey Solo",
             userIcon: UIImage(named: "rey")!,
             userImages: [UIImage(named: "mando")!, UIImage(named: "ben")!]),
        User(userName: "Rex Clone",
             userIcon: UIImage(named: "rex")!,
             userImages: [UIImage(named: "rian")!, UIImage(named: "ashoka")!]),
        User(userName: "Ben Solo",
             userIcon: UIImage(named: "ben")!,
             userImages: [UIImage(named: "rian")!, UIImage(named: "rey")!])
    ]
    
    lazy var sortedFriends: [[User]] = {
        return friends.sorted{ (lhs, rhs) in return lhs.getSurname() < rhs.getSurname() }.reduce([[User]]()) { (result, element) -> [[User]] in
            guard var last = result.last else { return [[element]] }
            var collection = result
            
            if element.getSurname().first == result.last?.first?.getSurname().first {
                last.append(element)
                collection[collection.count - 1] = last
            } else {
                collection.append([element])
            }
            
            return collection
        }
    }()
    
    var searchedFriends = [User]()
    var isSeraching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsSearchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSeraching {
            return 1
        } else {
            return sortedFriends.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSeraching {
            return searchedFriends.count
        } else {
            return sortedFriends[section].count
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Array(Set(friends.compactMap{$0.getSurname().first?.uppercased()})).sorted()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView()
        sectionHeader.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        let sectionCharacter = UILabel(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        sectionCharacter.text = String(sortedFriends[section][0].getSurname().first ?? "?")
        sectionCharacter.textColor = .black
        sectionHeader.addSubview(sectionCharacter)
        
        return sectionHeader
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsCell
        
        if isSeraching {
            cell.friendName.text = searchedFriends[indexPath.row].userName
            cell.friendIconImageView.image = searchedFriends[indexPath.row].userIcon
        } else {
            cell.friendName.text = sortedFriends[indexPath.section][indexPath.row].userName
            cell.friendIconImageView.image = sortedFriends[indexPath.section][indexPath.row].userIcon
        }
        
        cell.parentContainerView.shadow()
        cell.childContainerView.circle()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
        cell.childContainerView.addGestureRecognizer(tapGesture)

        return cell
    }
    
    // MARK: - Cell Icon Animation
    
    @objc func tap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? MyFriendsCell {
                    UIView.animate(withDuration: 0.1, animations: {
                        tappedCell.childContainerView.frame.size.width -= 5
                        tappedCell.childContainerView.frame.size.height -= 5
                        
                        tappedCell.friendIconImageView.frame.size.width -= 5
                        tappedCell.friendIconImageView.frame.size.height -= 5
                    }, completion:  { _ in
                        UIView.animate(withDuration: 1.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                            tappedCell.childContainerView.frame.size.width += 5
                            tappedCell.childContainerView.frame.size.height += 5
                            
                            tappedCell.friendIconImageView.frame.size.width += 5
                            tappedCell.friendIconImageView.frame.size.height += 5
                        })
                    })
                }
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var userName: String = "" //friends[indexPath.row].userName
                
                let destinationViewController = segue.destination as? UserPhotosController
                
                if isSeraching {
                    userName = searchedFriends[indexPath.row].userName
                    destinationViewController?.userNameTitle = userName
                    
                    for photo in searchedFriends[indexPath.row].userImages {
                        destinationViewController?.photos.append(photo)
                    }
                    
                } else {
                    userName = sortedFriends[indexPath.section][indexPath.row].userName
                    destinationViewController?.userNameTitle = userName
                    
                    for photo in sortedFriends[indexPath.section][indexPath.row].userImages {
                        destinationViewController?.photos.append(photo)
                    }
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
            searchedFriends = friends.filter( {$0.userName.range(of: friendsSearchBar.text!, options: .caseInsensitive) != nil} )
            tableView.reloadData()
        }
    }
}
