//
//  SignUpScreenViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/18/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class SignUpScreenViewController: UIViewController {
    // Varaibles that are tied to the fields on the Sign Up Page.
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function for when the User clicks on the "Sign Up" button.
    @IBAction func signUp(_ sender: AnyObject) {
        // Check to make sure that the Confirm Password field matches the Password Field
        if passwordConfirm.text != password.text {
            // If the passwords do not match, show a pop-up alert
            let alert = UIAlertController(title: "Sign Up Error", message: "Please make sure your passwords match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            // Create a new user object and save it to Parse
            let user = PFUser()
            user.username = email.text
            user.password = password.text
            user.email = email.text
            // If the save fails, show the error.
            user.signUpInBackground(block: { (succeeded: Bool, error: Error?) in
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
            })
            
        }
    }
}
