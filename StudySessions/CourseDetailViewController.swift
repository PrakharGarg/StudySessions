//
//  CourseDetailViewController.swift
//  StudySessions
//
//  Created by Elizabeth Haynes on 10/25/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class CourseDetailViewController: UIViewController {

    var detailCourse: PFObject?
    
    @IBOutlet var name: UILabel!
    @IBOutlet var professor: UILabel!
    let user = PFUser.current()
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = detailCourse?["name"] as? String
        professor.text = detailCourse?["professor"] as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func joinClass(_ sender: AnyObject) {
        let query = PFQuery(className:"Courses")
        query.getObjectInBackground(withId: (detailCourse?.objectId)!) { (course: PFObject?, error: Error?) in
            if error == nil {
//                course?["students"] += [(user?.objectId)!]
                print(course?["students"])
                if course?["students"] == nil {
                    course?["students"] = [(self.user?.objectId)!]
                }
                else {
                    course?.add((self.user?.objectId)!, forKey: "students")
                }
                course?.saveInBackground()
                let alert = UIAlertController(title: "Success", message: String(describing: "You have joined this class."), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }
        
        
        
    }
}
