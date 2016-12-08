//
//  AllPostsTableViewController.swift
//  StudySessions
//
//  Created by Naren Inukoti on 12/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AllPostsTableViewController: UITableViewController {
    
    
    var studySession: PFObject!
    var allPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find all posts for the current study sessions
        loadPosts()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        self.tableView.allowsSelection = true
        self.title = "All Posts"
    }
    
    // Refresh on View
    override func viewWillAppear(_ animated: Bool) {
        loadPosts()
    }
    
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        loadPosts()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //2 queries
    //first get objectIDs of posts in study session
    //second query posts table and get all postText for each objectId
    
    func loadPosts() {
        let studySessionId = studySession.objectId!
        let query = PFQuery(className:"Posts")
        query.whereKey("studySessionId", equalTo: studySessionId)
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if error == nil {
                self.allPosts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlePost", for: indexPath)

        let post = allPosts[indexPath.row]
        cell.textLabel?.text = post["postText"] as? String

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        if segue.identifier == "addNewPost" {
            let destination = segue.destination as! AddNewPostViewController
            
            destination.studySession = self.studySession!
        }
        if segue.identifier == "viewReplies" {
            let destination = segue.destination as! ViewRepliesViewController
            destination.post = allPosts[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    

}
