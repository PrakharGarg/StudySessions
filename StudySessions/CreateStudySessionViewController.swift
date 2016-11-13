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
    // Name textfield
    @IBOutlet var name: UITextField!
    // Description textfield
    @IBOutlet var studySessionDescription: UITextField!
      // Course textfield
    @IBOutlet var course: UITextField!
    // Time textfield
    @IBOutlet var time: UITextField!
    // Location textfield
    @IBOutlet var location: UITextField!
    // UIPickerview
    let pickerView = UIPickerView()
    
    // Variable that holds all of the courses for the current user
    var courses = [PFObject]()

   
    @IBOutlet weak var dateLabel: UITextField!
    
    @IBAction func datePickerAction(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        (sender as UITextField!).inputView = datePickerView
        
        
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
       
        
        self.dateLabel.text = dateFormatter.string(from: sender.date)
        
    }

    @IBAction func createSession(_ sender: AnyObject) {
        // Create a new study session
        let studySession = PFObject(className: "StudySessions")
        studySession["name"] = name.text
        studySession["description"] = studySessionDescription.text
        studySession["location"] = location.text!
        studySession["course"] = course.text
        studySession["time"] = dateLabel.text
        studySession["students"] = [(PFUser.current()?.objectId)!]
        
        studySession.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("YAY")
                // Show a success alert
                let alert = UIAlertController(title: "Success", message: String(describing: "You have created a Study Session"), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                // Clear the fields
                self.name.text = ""
                self.studySessionDescription.text = ""
                self.location.text = ""
                self.course.text = ""
                self.dateLabel.text = ""

            } else {
                // There was a problem, check error.description
            }
        }
    }

   override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title
        self.title = "Create a Study Session"
        // Hide keyboard when tapping outside field
        hideKeyboardWhenTappedAround()
        // Find all courses related to user
        findCourses()
        // Init the pickerView
        pickerView.delegate = self
        course.inputView = pickerView
    
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        findCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Find all of the courses for the current user by running a Parse query in the Courses model for the student's ID.
    func findCourses() {
        let user = PFUser.current()
        let query = PFQuery(className:"Courses")
        query.whereKey("students", equalTo:(user?.objectId)!)
        query.findObjectsInBackground { (object: [PFObject]?, error: Error?) in
            if error == nil {
                self.courses = object!
                self.courses.insert(PFUser.current()!, at: 0)
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
        if row == 0 {
            course.text = ""
        }
        else {
            course.text = courses[row]["name"] as! String?
        }
    }
}
