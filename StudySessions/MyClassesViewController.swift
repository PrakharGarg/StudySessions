//
//  MyClassesViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class MyClassesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Classes"
        
//        AddClasses()
//        showClasses()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showClasses(){
        let userId = PFUser.current()?.objectId as String!
        let query = PFQuery(className:"Courses")
        query.whereKey("students", equalTo: userId)
        query.findObjectsInBackground { (courses: [PFObject]?, error: Error?) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(courses!.count)")
                // Do something with the found objects
                print(courses)
                
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
        
    }
    
    
//    func AddClasses() {
//        let user = PFUser.current()
//        
//        let query = PFQuery(className:"Courses")
//        query.getObjectInBackground(withId: "Ynggk6jEQl") { (course: PFObject?, error: Error?) in
//            if error != nil {
//                print(error)
//            } else if let course = course {
//                course.addUniqueObjects(from: ["SjestbPm0z"], forKey: "students")
//                course.saveInBackground()
//            }
//
//        }
//        
//    }
}
