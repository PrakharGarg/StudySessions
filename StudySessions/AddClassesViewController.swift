//
//  testViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/25/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AddClassesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
    // Variable that holds all of the study sessions that are in the classes that the user is in.
    var allCourses = [PFObject]()
    var filteredCourses = [PFObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the page
        self.title = "Add a Class"
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
        searchController.searchBar.placeholder = "Search for a class"
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //search function
    func updateSearchResults(for searchController: UISearchController)
    {
        //do whatever with searchController here.
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        print("searchy search")
    }
    func filterContentForSearchText(searchText: String, scope: String = "All")
    {
        filteredCourses = allCourses.filter
            { course in
                return (((course["name"]) as AnyObject).lowercased).contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    
    // Function that runs a query to find all StudySessions objects that have the current user's id in it's list of students
    func findCourses() {
        let user = PFUser.current()
        let query = PFQuery(className:"Courses")
        query.whereKey("students", notEqualTo: (user?.objectId)!)
        query.findObjectsInBackground { (classes: [PFObject]?, error: Error?) in
            if error == nil {
                // print("SWEET")
                self.allCourses = classes!
                // Reload the page once this query is complete
                self.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of total study sessions in the array
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredCourses.count
        }
        else {
            return self.allCourses.count
        }
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySessionsCells", for: indexPath)
        let course:PFObject
        if searchController.isActive && searchController.searchBar.text != "" {
            course = filteredCourses[indexPath.row]
        }
        else {
            course = allCourses[indexPath.row]
        }

        cell.textLabel?.text = course["name"] as! String?
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCourse" {
            let destination = segue.destination as? CourseDetailViewController
            let courseIndex = tableView.indexPathForSelectedRow?.row
            if searchController.isActive && searchController.searchBar.text != "" {
                destination?.detailCourse = filteredCourses[courseIndex!]
            }
            else {
                destination?.detailCourse = allCourses[courseIndex!]
            }
        }
    }
}
