//
//  AddClassViewController.swift
//  StudySessions
//
//  Created by Elizabeth Haynes on 10/24/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AddClassViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allCourses = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Set the title of the view controller
        self.title = "My Classes"
        // Find all of the courses for the current user
        findAllCourses()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        print("loaded add course page")
    }
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        findAllCourses()
        refreshControl.endRefreshing()
    }
    // Find all of the courses for the current user by running a Parse query in the Courses model for the student's ID.
    func findAllCourses() {
        let query = PFQuery(className:"Courses")
        query.findObjectsInBackground { (object: [PFObject]?, error: Error?) in
            if error == nil {
                self.allCourses = object!
                self.tableView.reloadData()
                print("found courses, there are " + String(self.allCourses.count))
            }
        }
        print("done finding classes, there are " + String(self.allCourses.count))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("count" + String(self.allCourses.count))
        return self.allCourses.count
    }
    
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addClassCell", for: indexPath)
        print ("count2" + String(self.allCourses.count))
        let course = self.allCourses[indexPath.row]
        cell.textLabel?.text = (course["name"]) as? String
        cell.detailTextLabel?.text = (course["professor"]) as? String
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
