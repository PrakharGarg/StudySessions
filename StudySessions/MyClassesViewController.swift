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
    
    @IBOutlet weak var tableView: UITableView!
    // Variable that holds all of the courses for the current user
    var courses = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCoursesCell", for: indexPath) as! ShowCoursesTableCell
        let course = self.courses[indexPath.row]
        
        cell.delegate = self
        
        // Set the cell text to be the class name
        cell.class_name.text = (course["name"]) as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Function that allows for swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Find the class that we are trying to delete
            let currentClass = self.courses[indexPath.row]["name"]
            let query = PFQuery(className:"Courses")
            query.whereKey("name", equalTo: currentClass)
            query.findObjectsInBackground { (object: [PFObject]?, error: Error?) in
                if error == nil {
                    // Delete the user from the array of students for the class.
                    let userId = (PFUser.current()?.objectId)!
                    let deleteClass = object?[0]
                    var studentsInClass = deleteClass?["students"] as! Array<String>
                    
                    if let index = studentsInClass.index(of: userId) {
                        studentsInClass.remove(at: index)
                        object?[0]["students"] = studentsInClass
                        object?[0].saveInBackground()
                    }
                }
            }
            // Remove the class from the table
            courses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClassSessions" {
            let s_s = sender as! PFObject
            let destination = segue.destination as! ClassStudySessionsViewController
            
            destination.course = s_s
        }
    }
}

// function that gets called when someone presses the history button
extension MyClassesViewController: ShowCoursesTableCellDelegate {
    func goToSession(with cell: ShowCoursesTableCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let s_s = courses[indexPath.row]
        performSegue(withIdentifier: "showClassSessions", sender: s_s)
    }
    
}
