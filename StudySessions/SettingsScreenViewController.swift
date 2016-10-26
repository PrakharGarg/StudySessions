//
//  SettingsScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

// This view is the settings page off of the Home Page. It is connected via the Navigation Controller
class SettingsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Table view delegate
    @IBOutlet var tableView: UITableView!
    // Variable that holds all of the courses for the current user
    var courses = [PFObject]()
    // Holds the user's emails
    @IBOutlet var emailLabel: UITextField!
    // Holds the user's password
    @IBOutlet var passwordLabel: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Set the title of the view controller
        self.title = "User Settings"
        // Find all of the courses for the current user
        findCourses()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        // Populate the labels
        let user = PFUser.current()
        emailLabel.text = user?["email"] as? String
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath) as! CoursesTableViewCell
        let courses = self.courses[indexPath.row]
        cell.courseLabel.text = (courses["name"]) as? String
 
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Logout button performs an unwind segue
    @IBAction func logout(_ sender: AnyObject) {
        print("logging out")
        PFUser.logOut()
        self.performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    @IBAction func saveButton(_ sender: AnyObject) {
        PFUser.enableAutomaticUser()
        let newEmail = emailLabel.text
        let newPass = passwordLabel.text
        let user = PFUser.current()
//        PFUser.current()?.email = newEmail
//        user?.password = newPass
        user?.email = newEmail
        user?.username = newEmail
        user?.password = newPass
//        PFUser.current()?.setValue(emailLabel.text, forKey: "email")
        user?.saveInBackground()
        
        let alert = UIAlertController(title: "Success", message: String(describing: "You have successfully updated your profile."), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
}
