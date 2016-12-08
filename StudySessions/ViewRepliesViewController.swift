//
//  ViewRepliesViewController.swift
//  StudySessions
//
//  Created by Naren Inukoti on 12/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class ViewRepliesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var post: PFObject!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postText: UILabel!
    var allResponses = [String]()
    @IBOutlet weak var responseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.text! = post?["postText"] as! String
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Find all replies for the current post
        loadResponses()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        self.tableView.allowsSelection = true
        self.title = "All Responses"
    }
    
    // Refresh on View
    override func viewWillAppear(_ animated: Bool) {
        loadResponses()
    }
    
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        loadResponses()
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddResponseBtn(_ sender: Any) {
        if responseTextField.text == nil || responseTextField.text! == ""{
            //Alerts user and returns to View Files view
            let alertController = UIAlertController(
                title: "Error",
                message: "Please enter a response.",
                preferredStyle: .alert
            )
            
            let OKAction = UIAlertAction(
            title: "Okay", style: .default) { (action:UIAlertAction!) in
                // ...
            }
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
        } else {
            if post?["replies"] == nil {
                post?["replies"] = [responseTextField.text]
            } else {
                post?.add(responseTextField.text!, forKey: "replies")
            }
            post?.saveInBackground()
            
            //Alerts user and returns to View Files view
            let alertController = UIAlertController(
                title: "Yay!",
                message: "Response has successfully been added.",
                preferredStyle: .alert
            )
            
            let OKAction = UIAlertAction(
            title: "Okay", style: .default) { (action:UIAlertAction!) in
                self.responseTextField.text! = ""
                self.tableView.reloadData()
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true, completion:nil)
        }

    }
    
    func loadResponses(){
        post.fetchInBackground()
        allResponses = post?["replies"] as! [String]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allResponses.count
    }
    
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyTableViewCell
        cell.replyPostLabel.text = allResponses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ReplyTableViewCell
        let alertController = UIAlertController(
            title: "Response",
            message: cell.replyPostLabel.text!,
            preferredStyle: .alert
        )
        
        let OKAction = UIAlertAction(
        title: "Close", style: .default) { (action:UIAlertAction!) in
            // ...
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true, completion:nil)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
