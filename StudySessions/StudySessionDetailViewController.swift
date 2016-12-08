//
//  classDetailViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class StudySessionDetailViewController: UIViewController {
    
    
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var course: UILabel!
    @IBOutlet var descriptionBox: UILabel!
    @IBOutlet var people: UILabel!
    
    var studySession: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        
        self.title = studySession["name"] as? String
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetup(){
        let date = studySession["date"] as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy hh:mm a"
        
        let studentIds = studySession["students"] as! Array<String>
        var tempString = ""
        
        let query = PFUser.query()
        query?.whereKey("objectId", containedIn: studentIds)
        query?.findObjectsInBackground(block: { (students: [PFObject]?, error: Error?) in
            if error == nil {
                for student in students! {
                   tempString += (" " + (student["username"] as! String) + "\n")
                }
                self.dateAndTime.text = formatter.string(from: date) as String
                self.location.text = self.studySession?["location"] as? String
                self.course.text = self.studySession?["course"] as? String
                self.descriptionBox.text = self.studySession?["description"] as? String

                self.people.text = tempString
                
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFiles") {
            let destination = segue.destination as! ViewFilesViewController
            destination.studySession = self.studySession
        }
        if(segue.identifier == "discussionBoard") {
            let destination = segue.destination as! AllPostsTableViewController
            destination.studySession = self.studySession
        }
    }
}
