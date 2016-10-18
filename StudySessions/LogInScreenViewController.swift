//
//  LogInScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class LogInScreenViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set all of the fields to be empty
        email.text = ""
        password.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logIn(_ sender: AnyObject) {

        PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                let alert = UIAlertController(title: "Sign Up Error", message: String(describing: error.localizedDescription), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
                // If the save is successful, segue to the main page
            else {
                print("YAY!")
                self.performSegue(withIdentifier: "LogInToMain", sender: nil)
            }
        }
    }
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        email.text = ""
        password.text = ""
    }
    
    
}
