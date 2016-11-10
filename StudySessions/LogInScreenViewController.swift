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
    // Login Credentials filled in by the User
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        // Set the title
        self.title = "Log In"
        // Set all of the fields to be empty
        if PFUser.current() != nil {
            let user = PFUser.current()
            email.text = user?.username
        }
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // Function that is used to login
    @IBAction func logIn(_ sender: AnyObject) {
        // Take the login credentials from the fields and try and login with Parse
        PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user: PFUser?, error: Error?) in
            // If there is an error, present a pop-up with the error
            if let error = error {
                let alert = UIAlertController(title: "Sign Up Error", message: String(describing: error.localizedDescription), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            // If the save is successful, segue to the main page
            else {
                print("YAY!")
               let controller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController")
            
                self.present(controller!, animated: true, completion: { () -> Void in
                })
            }
        }
    }
    // Segue when the User logs out
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // Set the fields to be empty
        let user = PFUser.current()
        email.text = user?.username
        password.text = ""
    }
}
