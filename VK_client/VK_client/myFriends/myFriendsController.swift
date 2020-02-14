//
//  myFriendsController.swift
//  VK_client
//
//  Created by Полина Войтенко on 11.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class myFriendsController: UITableViewController {
    
    var friends: [User] = [
        User(userName: "John Smith", userIcon: UIImage(named: "oscars")!, userImages: [UIImage(named: "oscars")!]),
        User(userName: "Chelsea Moore", userIcon: UIImage(named: "mando")!, userImages: [UIImage(named: "mando")!]),
        User(userName: "Daisy Tucker", userIcon: UIImage(named: "rian")!, userImages: [UIImage(named: "rian")!])
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! myFriendsCell

        let friendName = friends[indexPath.row].userName
        let friendIcon = friends[indexPath.row].userIcon
        
        cell.friendName.text = friendName
        cell.friendIcon.image = friendIcon

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPhotos" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let userName = friends[indexPath.row].userName
                
                let destinationViewController = segue.destination as? userPhotosController
                destinationViewController?.userNameTitle = userName
                
                for photo in friends[indexPath.row].userImages {
                    destinationViewController?.photos.append(photo)
                }
            }
            
        }
    }


}
