//
//  AddNewPostViewController.swift
//  StudySessions
//
//  Created by Naren Inukoti on 12/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AddNewPostViewController: UIViewController {
    
    var studySession: PFObject!

    @IBOutlet weak var newPostText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postBtn(_ sender: Any) {
        if(newPostText.text == "" || newPostText == nil) {
            let alertController = UIAlertController(
                title: "Error",
                message: "Please select a file to upload.",
                preferredStyle: .alert
            )
            let OKAction = UIAlertAction(
            title: "Okay", style: .default) { (action:UIAlertAction!) in
                // ...
            }
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
        } else {
            //add new post
            let newPost = PFObject(className: "Posts")
            newPost.setObject(newPostText.text!, forKey: "postText")
            newPost.setObject(studySession.objectId!, forKey: "studySessionId")
            newPost.setObject([String](), forKey: "replies")
            newPost.saveInBackground()
            let alertController = UIAlertController(
                title: "Yay!",
                message: "New Post has successfully been added.",
                preferredStyle: .alert
            )
            
            let OKAction = UIAlertAction(
            title: "Okay", style: .default) { (action:UIAlertAction!) in
                self.newPostText.text = ""
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true, completion:nil)
        }
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
