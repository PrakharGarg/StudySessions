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
    
    var studySession: PFObject!
    
    
    var peopleInStudySession = [PFObject]()
    var people_names = [String]()
    let userId = (PFUser.current()?.objectId)!
    
    @IBOutlet var joinBtn: UIButton!
    
    @IBAction func joinStudySession(_ sender: AnyObject) {
        
        let query = PFQuery(className:"StudySessions")
        query.whereKey("objectId", equalTo: (studySession.objectId)!)
        query.findObjectsInBackground { (session: [PFObject]?, error: Error?) in
            if error == nil {
                let tempSession = session?.first
                // Add the current student to the Study Session model.
                tempSession?.addUniqueObjects(from: [self.userId], forKey: "students")
                tempSession?.saveInBackground(block: { (done: Bool, error: Error?) in
                    if error == nil {
                        let joinBtn = sender as! UIButton
                        joinBtn.isEnabled = false
                        joinBtn.setTitle("Joined", for: .disabled)
                        
                    }
                    
                })
                
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetup(){
        dateAndTime.text = studySession?["time"] as? String
        location.text = studySession?["location"] as? String
        course.text = studySession?["course"] as? String
        descriptionBox.text = studySession?["description"] as? String
        people.text = getPeople(peopleArray: studySession?["students"] as! Array<String>)
        
        if (studySession["students"] as! Array).contains(userId) {
            joinBtn.isEnabled = false
            joinBtn.setTitle("Joined", for: .disabled)
            
        }
        else {
            joinBtn.setTitle("Join", for: .normal)
        }
    }
    
    func getPeople(peopleArray: Array<String>) -> String {
        //for each string in array find persons name
        /*var people_names = Array<String>()
         let query = PFQuery(className:"User")
         query.whereKey("objectId", containedIn: peopleArray)
         query.findObjectsInBackground { (peopleInSS: [PFObject]?, error: Error?) in
         if error == nil {
         for person in peopleInSS! {
         people_names.append(person["username"] as! String)
         }
         }
         }
         return people_names.joined(separator: ",")*/
        return peopleArray.joined(separator: ", ")
    }
    
}
