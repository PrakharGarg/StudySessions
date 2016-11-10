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
class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    // Variable that holds all of the study sessions that are in the classes that the user is in.
    var studySessions = [PFObject]()
    var filteredSessions = [PFObject]()
    // Variable that holds all of the classes for the current user
    var currentClasses = [PFObject]()
    // The TableView outlet
    @IBOutlet var tableView: UITableView!
    // Toggle to determine whether to see all sessions or just the ones you've joined
    // On = view ones you've joined
    @IBOutlet weak var toggleSessions: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var class_names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the page
        self.title = "Study Sessions"
        // Make a refresh controller for when users pull down on the table. This refresehes the data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        
        //search controller settings
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //search bar visual settings
        searchController.searchBar.placeholder = "Search for a study session"
        searchController.searchBar.showsCancelButton = true
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
    
    //search function
    func updateSearchResults(for searchController: UISearchController)
    {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        filteredSessions = studySessions.filter
            { course in
                return (((course["name"]) as AnyObject).lowercased).contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function that runs a query to find all Courses objects that have the current user's id in it's list of students.
    // After we find all of the student's courses, we find all study sessions and filter them by the classes that the user is a part of.
    func findCourses() {
        let userId = (PFUser.current()?.objectId)!
        let query = PFQuery(className:"Courses")
        query.whereKey("students", equalTo: userId)
        query.findObjectsInBackground { (classes: [PFObject]?, error: Error?) in
            if error == nil {
                // print("SWEET")
                self.currentClasses = classes!
                // Create an array of all of the class names that the student is a part of.
                for course in self.currentClasses {
                    self.class_names.append((course["name"])! as! String)
                }
                // Run a new query to find all study sessions.
                let sessionQuery = PFQuery(className: "StudySessions")
                sessionQuery.findObjectsInBackground( block: { (sessions: [PFObject]?, error: Error?) in
                    if error == nil {
                        self.studySessions = sessions!
                    }
                })
                // Reload the page once this query is complete
                self.tableView.reloadData()
            }
        }
        // Filter the study sessions to only show the ones that are in the classes that the user is in.
        filterSessions()
    }
    // Filter out study sessions that the user is not interested in.
    func filterSessions(){
        for session in self.studySessions {
            if self.class_names.contains((session["course"])! as! String){
                // keep it
            }
            else {
                let index = self.studySessions.index(of: session)
                self.studySessions.remove(at: index!)
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
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of total study sessions in the array
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredSessions.count
        }
        else {
            return self.studySessions.count
        }
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySessionsCell", for: indexPath)
        let studySession:PFObject
        if searchController.isActive && searchController.searchBar.text != "" {
            studySession = filteredSessions[indexPath.row]
        }
        else {
            studySession = studySessions[indexPath.row]
        }
        cell.textLabel?.text = studySession["name"] as! String?
        cell.detailTextLabel?.text = studySession["course"] as! String?
        
        return cell
    }
}
