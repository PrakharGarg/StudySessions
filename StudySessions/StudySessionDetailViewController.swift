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

    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var descriptionBox: UILabel!
    @IBOutlet weak var people: UILabel!
 
    var peopleInStudySession = [PFObject]()
    var people_names = [String]()
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
