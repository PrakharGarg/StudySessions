//
//  AddClassViewController.swift
//  StudySessions
//
//  Created by Elizabeth Haynes on 10/24/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AddClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    // Table view delegate
    @IBOutlet var tableView: UITableView!
    // Variable that holds all of the courses for the current user
    var allCourses = [PFObject]()
    var filteredCourses = [PFObject]()
    //does actual search capabilities
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Set the title of the view controller
        self.title = "Add Class"
        // Find all of the courses for the current user
        findAllCourses()
        // Allow users to refresh the page if the pull down
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
            }
        }
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
    
    //table functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return self.filteredCourses.count
        }
        else
        {
            return self.allCourses.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCoursesCell", for: indexPath) as! CoursesTableViewCell
        let course:PFObject
        if searchController.isActive && searchController.searchBar.text != ""
        {
            course = filteredCourses[indexPath.row]
        }
        else
        {
            course = allCourses[indexPath.row]
        }
        
        cell.courseLabel.text = (course["name"]) as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourseDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let course = allCourses[(indexPath as NSIndexPath).row]
                let controller = (segue.destination as! UINavigationController).topViewController as! CourseDetailViewController
                controller.detailCourse = course
                /*controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true*/
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
