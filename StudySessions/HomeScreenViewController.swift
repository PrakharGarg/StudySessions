//
//  HomeScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var studySessions = [PFObject]()
    
    // The TableView outlet
    @IBOutlet var tableView: UITableView!
    // Toggle to determine whether to see all sessions or just the ones you've joined
    // On = view ones you've joined
    @IBOutlet weak var toggleSessions: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Study Sessions"
        findCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findCourses() {
        let userId = (PFUser.current()?.objectId)!
        let query = PFQuery(className:"StudySessions")
        query.whereKey("students", equalTo: userId)
        query.findObjectsInBackground { (students: [PFObject]?, error: Error?) in
            if error == nil {
                print("SWEET")
                self.studySessions = students!
                
                self.tableView.reloadData()
            }
        }
    }
    // Override the back button for the settings page to "Home"
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

        print(self.studySessions.count)
        return self.studySessions.count
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySessionsCell", for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
//                                   reuseIdentifier: "studySessionsCell")
//        }
        let studySession = studySessions[indexPath.row]
        cell.textLabel?.text = studySession["name"] as! String?
        print(studySession["course"])
        cell.detailTextLabel?.text = studySession["course"] as! String?
        
        
        
        return cell
    }
}
