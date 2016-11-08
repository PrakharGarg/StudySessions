//
//  MyClassesViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class MyClassesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Table view delegate
    @IBOutlet var tableView: UITableView!
    // Variable that holds all of the courses for the current user
    var courses = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allow user to delete a course
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Set the title of the view controller
        self.title = "My Classes"
        // Find all of the courses for the current user
        findCourses()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
    }
    
    // Refresh on View
    override func viewWillAppear(_ animated: Bool) {
        findCourses()
    }
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        findCourses()
        refreshControl.endRefreshing()
    }
    // Find all of the courses for the current user by running a Parse query in the Courses model for the student's ID.
    func findCourses() {
        let user = PFUser.current()
        let query = PFQuery(className:"Courses")
        query.whereKey("students", equalTo:(user?.objectId)!)
        query.findObjectsInBackground { (object: [PFObject]?, error: Error?) in
            if error == nil {
                self.courses = object!
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCoursesCell", for: indexPath) as! CoursesTableViewCell
        let course = self.courses[indexPath.row]
        cell.courseLabel.text = (course["name"]) as? String
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            courses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("add???")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
 }
