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
    
    @IBOutlet var dateAndTime: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var course: UILabel!
    @IBOutlet var descriptionBox: UILabel!
    @IBOutlet var people: UILabel!
    
    
    
    var studySession: PFObject!

    
    var peopleInStudySession = [PFObject]()
    var people_names = [String]()
    let userId = (PFUser.current()?.objectId)!
    
    
    
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
//        let peopleArray = getPeople()
//        people.text = getPeople()
        
    }
    
    func getPeople() {
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
        
//        let query = 
//        return peopleArray.joined(separator: ", ")
    }
    
}
