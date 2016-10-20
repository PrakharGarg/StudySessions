//
//  CreateStudySessionViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class CreateStudySessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create a Study Session"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// SAMPLE CREATE SESSION QUERY
//    var studySession = PFObject(className: "StudySessions")
//    studySession["name"] = "Test #3"
//    studySession["description"] = "foo"
//    studySession["location"] = "GDC 3.12"
//    studySession["course"] = "CS429"
//    studySession["time"] = "5:30pm"
//    studySession["students"] = ["SjestbPm0z"]
//    
//    studySession.saveInBackground { (success: Bool, error: Error?) in
//        if (success) {
//            print("YAY")
//        } else {
//        // There was a problem, check error.description
//        }
//    }
    
    
}
