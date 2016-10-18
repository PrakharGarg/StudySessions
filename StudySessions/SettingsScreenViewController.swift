//
//  SettingsScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class SettingsScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Settings"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(_ sender: AnyObject) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
}
