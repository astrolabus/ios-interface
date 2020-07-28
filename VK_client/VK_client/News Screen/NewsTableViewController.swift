//
//  NewsTableViewController.swift
//  VK_client
//
//  Created by Полина Войтенко on 27.02.2020.
//  Copyright © 2020 Полина Войтенко. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var newsData = [
        NewsPost(userIcon: UIImage(named: "leia"), userName: "Leia Organa", postDate: "17.03.20", postContent: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae faucibus nulla, non sodales libero. Cras tincidunt pharetra leo, at laoreet lacus rutrum at. Curabitur ultricies augue et nunc eleifend, vitae pharetra erat pretium. Quisque interdum ultrices leo eget placerat. Suspendisse vel mauris sed nisl commodo faucibus.", postImage: nil, postType: .post),
        NewsPost(userIcon: UIImage(named: "han"), userName: "Han Solo", postDate: "18.03.20", postContent: "", postImage: UIImage(named: "padme"), postType: .photo),
        NewsPost(userIcon: UIImage(named: "ashoka"), userName: "Ashoka Tano", postDate: "16.03.20", postContent: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae faucibus nulla, non sodales libero. Cras tincidunt pharetra leo, at laoreet lacus rutrum at. Curabitur ultricies augue et nunc eleifend, vitae pharetra erat pretium. Quisque interdum ultrices leo eget placerat. Suspendisse vel mauris sed nisl commodo faucibus. Mauris vel ipsum nec neque rutrum laoreet. Nunc a risus sit amet elit volutpat fermentum. Aliquam urna est, gravida at ligula ac, congue porttitor nulla. Quisque blandit pharetra accumsan. Etiam in massa dui.", postImage: nil, postType: .post),
        NewsPost(userIcon: UIImage(named: "din"), userName: "Mando", postDate: "16.03.20", postContent: "", postImage: UIImage(named: "ezra"), postType: .photo)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if newsData[indexPath.row].postType == .post {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsPostCell", for: indexPath) as! NewsPostTableViewCell
            
            cell.userIcon.image = newsData[indexPath.row].userIcon
            cell.userName.text = newsData[indexPath.row].userName
            cell.postDate.text = newsData[indexPath.row].postDate
            
            cell.postContent.text = newsData[indexPath.row].postContent
            
            cell.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: cell.postContent.bottomAnchor).isActive = true
            cell.shapeContainer.circle()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCell", for: indexPath) as! NewsPhotoTableViewCell
            
            cell.userIcon.image = newsData[indexPath.row].userIcon
            cell.userName.text = newsData[indexPath.row].userName
            cell.postDate.text = newsData[indexPath.row].postDate
            
            cell.postImage.image = newsData[indexPath.row].postImage
            
            cell.shapeContainer.circle()
            
            return cell
        }
        
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
