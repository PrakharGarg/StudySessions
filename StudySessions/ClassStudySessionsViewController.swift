//
//  ClassStudySessionsViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/25/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class ClassStudySessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var course:PFObject!

    // Variable that holds all of the study sessions that are in the classes that the user is in.
    var studySessions = [PFObject]()
    var filteredSessions = [PFObject]()
    // The TableView outlet
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the page
        self.title = course["name"] as! String
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
        
        // Find all study sessions when the page is loaded.
        findCourses()
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
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All"){
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
        let query = PFQuery(className:"StudySessions")
        let courseName = course["name"] as! String
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackground { (sessions: [PFObject]?, error: Error?) in
            if error == nil {
                // print("SWEET")
                self.studySessions = sessions!
                self.filterSessions()
            }
        }
    }
    
    // Filter out study sessions that the user is not interested in.
    func filterSessions(){
        let userId = (PFUser.current()?.objectId)!
        for session in studySessions {
            let index = self.studySessions.index(of: session)
            
                if (session["students"] as! Array).contains(userId){
                        // keep it
                }
                else {
                    self.studySessions.remove(at: index!)
                }
        }
        self.studySessions.sort{ ($0["date"] as! Date) < ($1["date"] as! Date) }
        self.tableView.reloadData()
    }
    // Override the back button for the settings page to "Home" since the current title is too long
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Called when the -> is pressed.
        if segue.identifier == "classShowStudySession" {
            let s_s = sender as! PFObject
            let destination = segue.destination as! StudySessionDetailViewController
            
            destination.studySession = s_s
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredSessions.count
        }
        else {
            
            return self.studySessions.count
        }
        
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classShowStudySession", for: indexPath) as! CourseStudySessionTableViewCell
        
        let studySession:PFObject
        
        // If we are filtering the search
        if searchController.isActive && searchController.searchBar.text != "" {
            studySession = filteredSessions[indexPath.row]
        }
        else {
            studySession = studySessions[indexPath.row]
        }
        
        cell.delegate = self
        
        cell.studySession = [studySession]
        let date = studySession["date"] as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm a"
        let dateString = formatter.string(from: date)
        cell.title_time.text = (studySession["name"] as! String?)! + " - " + dateString
        cell.class_name.text = (studySession["course"] as! String?)!
        
        let userId = (PFUser.current()?.objectId)!
        

        return cell
    }
    
    // Bool to track if a cell is being interacted with
    var thereIsCellTapped = false
    // Default value we will use to check.
    var selectedRowIndex = -1
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Expand tapped rows and return untapped cells to normal height
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            return 145
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CourseStudySessionTableViewCell
        let studySession = studySessions[indexPath.row]
        // Set the number of lines for a tapped cell
        cell.title_time.numberOfLines = 5
        // If a cell has been untapped, we want to reset it to its defaults
        if self.selectedRowIndex != -1 {
            let date = studySession["date"] as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm a"
            let dateString = formatter.string(from: date)
            
            (self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath) as! CourseStudySessionTableViewCell).title_time.text = (studySession["name"] as! String?)! + " - " + dateString
        }
        // If a cell has been tapped, show the extra info.
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
            
            let description = "Description: " + (studySession["description"] as! String?)!
            let location = "Location: " + (studySession["location"] as! String?)!
            let count = (studySession["students"] as! Array<Any>).count
            let peopleCount = "Going: " + count.description
            cell.title_time.text = (cell.title_time.text! + "\n\n" + description + "\n" + location + "\n" + peopleCount + "\n")
            cell.title_time.numberOfLines = 6
        }
            // All other cells should be default.
        else {
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
            cell.title_time.numberOfLines = 1
            let date = studySession["date"] as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm a"
            let dateString = formatter.string(from: date)
            
            cell.title_time.text = (studySession["name"] as! String?)! + " - " + dateString
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        }
        // Update the table
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

// function that gets called when someone presses the -> button
extension ClassStudySessionsViewController: CourseStudySessionTableViewCellDelegate {
    func goToSessions(with cell: CourseStudySessionTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let s_s = studySessions[indexPath.row]
        performSegue(withIdentifier: "classShowStudySession", sender: s_s)
    }
    
}
