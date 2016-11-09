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
    // Variable that holds all of the classes for the current user
    var currentClasses = [PFObject]()
    // The TableView outlet
    @IBOutlet var tableView: UITableView!
    // Toggle to determine whether to see all sessions or just the ones you've joined
    // On = view ones you've joined
    @IBOutlet var studySessionToggle: UISwitch!
    
    var class_names = [String]()
    
    @IBAction func toggleChanged(_ sender: Any) {
        findCourses()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the page
        self.title = "Study Sessions"
        // Make a refresh controller for when users pull down on the table. This refresehes the data
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
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
                        // Filter the study sessions to only show the ones that are in the classes that the user is in.
                        self.filterSessions()
                    }
                })
            }
        }
    }
    // Filter out study sessions that the user is not interested in.
    func filterSessions(){
        let userId = (PFUser.current()?.objectId)!
        for session in studySessions {
            
            if self.class_names.contains((session["course"])! as! String){
                // keep it
                // If the toggle is turned on, only get the sessions that the user is a part of. 
                if studySessionToggle.isOn {
                    if (session["students"] as! Array).contains(userId){
                        // keep it
                    }
                    else {
                        let index = self.studySessions.index(of: session)
                        self.studySessions.remove(at: index!)
                    }
                }
            }
            // Remove all study sessions that are in classes that the user is not a part of.
            else {
                let index = self.studySessions.index(of: session)
                self.studySessions.remove(at: index!)
            }
        }
        self.tableView.reloadData()
    }
    // Override the back button for the settings page to "Home" since the current title is too long
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
        // Called when the -> is pressed.
        if segue.identifier == "NAREEN CHANGE THIS" {
            let s_s = sender as! PFObject
            let destination = segue.destination
            // NAREEN WE NEED TO MAKE A CLASS ATTRIBUTE IN YOUR VIEW CONTROLLER THAT THIS SEGUES TO WITH THE NAME studySession THAT WILL HOLD THE SESSION
            destination.studySession = ss
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySessionsCell", for: indexPath) as! StudySessionTableViewCell
        let studySession = studySessions[indexPath.row]

        cell.delegate = self
        
        cell.studySession = [studySession]
        
        cell.title_time.text = (studySession["name"] as! String?)! + " - " + (studySession["time"] as! String?)!
        cell.className.text = (studySession["course"] as! String?)!

        let userId = (PFUser.current()?.objectId)!
        
        // If the user is already in the study session, make the button an arrow. Else make it a join button
        if (studySession["students"] as! Array).contains(userId) {
            cell.studySessionButtonLabel.setTitle("->", for: .normal)
            
        }
        else {
            cell.studySessionButtonLabel.setTitle("Join", for: .normal)
        }

        return cell
    }
    
    // Bool to track if a cell is being interacted with
    var thereIsCellTapped = false
    // Default value we will use to check.
    var selectedRowIndex = -1
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Expand tapped rows and return untapped cells to normal height
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            return 120
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! StudySessionTableViewCell
        let studySession = studySessions[indexPath.row]
        // Set the number of lines for a tapped cell
        cell.title_time.numberOfLines = 5
        // If a cell has been untapped, we want to reset it to its defaults
        if self.selectedRowIndex != -1 {
            (self.tableView.cellForRow(at: NSIndexPath(row: self.selectedRowIndex, section: 0) as IndexPath) as! StudySessionTableViewCell).title_time.text = (studySession["name"] as! String?)! + " - " + (studySession["time"] as! String?)!
        }
        // If a cell has been tapped, show the extra info.
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
            
            let description = "Description: " + (studySession["description"] as! String?)!
            let location = "Location: " + (studySession["location"] as! String?)!
            
            cell.title_time.text = (cell.title_time.text! + "\n\n" + description + "\n" + location + "\n")
            cell.title_time.numberOfLines = 5
        }
        // All other cells should be default.
        else {
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
            cell.title_time.numberOfLines = 1
            cell.title_time.text = (studySession["name"] as! String?)! + " - " + (studySession["time"] as! String?)!
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        }
        // Update the table
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    
}
// function that gets called when someone presses the -> button
extension HomeScreenViewController: StudySessionTableViewCellDelegate {
    func goToSession(with cell: StudySessionTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let s_s = studySessions[indexPath.row]
        performSegue(withIdentifier: "NAREEN CHANGE THIS", sender: s_s)
    }
    
}

