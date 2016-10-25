//
//  HomeScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//
import UIKit
import Parse

// This view controller is the main View that users will see when the launch the app.
// This view is hooked up to a Navigation Controller
class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Variable that holds all of the study sessions that are in the classes that the user is in.
    var studySessions = [PFObject]()
    // The TableView outlet
    @IBOutlet var tableView: UITableView!
    // Toggle to determine whether to see all sessions or just the ones you've joined
    // On = view ones you've joined
    @IBOutlet weak var toggleSessions: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the page
        self.title = "Study Sessions"
        // Make a refresh controller for when users pull down on the table. This refresehes the data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Find all of the courses that we need to display
        findCourses()
    }
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        findCourses()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function that runs a query to find all StudySessions objects that have the current user's id in it's list of students
    func findCourses() {
        let userId = (PFUser.current()?.objectId)!
        let query = PFQuery(className:"StudySessions")
        query.whereKey("students", equalTo: userId)
        query.findObjectsInBackground { (students: [PFObject]?, error: Error?) in
            if error == nil {
                // print("SWEET")
                self.studySessions = students!
                // Reload the page once this query is complete
                self.tableView.reloadData()
            }
        }
    }
    // Override the back button for the settings page to "Home" since the current title is too long
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of total study sessions in the array
        return self.studySessions.count
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySessionsCell", for: indexPath)
        let studySession = studySessions[indexPath.row]
        cell.textLabel?.text = studySession["name"] as! String?
        cell.detailTextLabel?.text = studySession["course"] as! String?
        
        return cell
    }
}
