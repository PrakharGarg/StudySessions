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
    
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var courseName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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