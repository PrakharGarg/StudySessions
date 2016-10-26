//
//  CreateStudySessionViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class CreateStudySessionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var name: UITextField!
    
    @IBOutlet var studySessionDescription: UITextField!
    @IBOutlet var classPicker: UIPickerView!

    @IBOutlet var course: UITextField!
    @IBOutlet var time: UITextField!
    @IBOutlet var location: UITextField!
    let pickerView = UIPickerView()
    
    // Variable that holds all of the courses for the current user
    var courses = [PFObject]()

    
    @IBAction func createSession(_ sender: AnyObject) {

        let studySession = PFObject(className: "StudySessions")
        studySession["name"] = name.text
        studySession["description"] = studySessionDescription.text
        studySession["location"] = location.text!
        studySession["course"] = course.text
        studySession["time"] = time.text
        studySession["students"] = [(PFUser.current()?.objectId)!]
        
        studySession.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("YAY")
                let alert = UIAlertController(title: "Success", message: String(describing: "You have created a Study Session"), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.name.text = ""
                self.studySessionDescription.text = ""
                self.location.text = ""
                self.course.text = ""
                self.time.text = ""

            } else {
                // There was a problem, check error.description
            }
        }
    }

    
   override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create a Study Session"
        hideKeyboardWhenTappedAround()
        findCourses()
    
    
        pickerView.delegate = self
        course.inputView = pickerView
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Find all of the courses for the current user by running a Parse query in the Courses model for the student's ID.
    func findCourses() {
        let user = PFUser.current()
        let query = PFQuery(className:"Courses")
        query.whereKey("students", equalTo:(user?.objectId)!)
        query.findObjectsInBackground { (object: [PFObject]?, error: Error?) in
            if error == nil {
                self.courses = object!
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courses[row]["name"] as! String?
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        course.text = courses[row]["name"] as! String?
    }
}
