//
//  NewsTableViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var news = [
        NewsPost(userIcon: UIImage(named: "anakin"), userName: "Anakin Skywalker", postDate: "13.02.2020", postText: "Some text", postImage: UIImage(named: "rian")),
        NewsPost(userIcon: UIImage(named: "ashoka"), userName: "Ashoka Tano", postDate: "14.02.2020", postText: "Another text", postImage: UIImage(named: "oscars")),
        NewsPost(userIcon: UIImage(named: "padme"), userName: "Padme Amidala", postDate: "15.02.2020", postText: "Something about senate", postImage: UIImage(named: "mando")),
        NewsPost(userIcon: UIImage(named: "rex"), userName: "Rex", postDate: "17.02.2020", postText: "Ugh", postImage: UIImage(named: "mando"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell

        cell.userIconImageView.image = news[indexPath.row].userIcon
        cell.userNameLabel.text = news[indexPath.row].userName
        cell.postDateLabel.text = news[indexPath.row].postDate
        
        cell.postTextLabel.text = news[indexPath.row].postText
        cell.postImageView.image = news[indexPath.row].postImage
        
        cell.postImageView.layer.cornerRadius = 20
        cell.userIconImageView.layer.cornerRadius = cell.userIconImageView.frame.height / 2

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
