//
//  AddNewFileViewController.swift
//  StudySessions
//
//  Created by Naren Inukoti on 11/26/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class AddNewFileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var studySession: PFObject!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var imageFileName: UITextField!
    
    
    @IBAction func addFromCameraBtn(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
        
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addFromPhotoLibraryBtn(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveAndAddNewFile(_ sender: AnyObject) {
        //if no image is selected ...
        if imageView.image == nil || imageFileName == nil{
            //Alerts user and returns to View Files view
            let alertController = UIAlertController(
                title: "Error",
                message: "Please select a file to upload and enter a file name.",
                preferredStyle: .alert
            )
            
            let OKAction = UIAlertAction(
            title: "Okay", style: .default) { (action:UIAlertAction!) in
                // ...
            }
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
        } else {
            //Saves to study session files as NSData -- need to convert to UIImage to display
            let imageData:NSData = NSData(data: UIImageJPEGRepresentation(imageView.image! , 0.7)!)
            
            let imageFile:PFFile = PFFile(data: imageData as Data)!
            if studySession?["files"] == nil {
                studySession?["files"] = [imageFile]
            } else {
                studySession?.add(imageFile, forKey: "files")
            }
            studySession?.saveInBackground()
            
            //Alerts user and returns to View Files view
            let alertController = UIAlertController(
                title: "Yay!",
                message: "File has successfully been added.",
                preferredStyle: .alert
            )
        
            let OKAction = UIAlertAction(
                title: "Okay", style: .default) { (action:UIAlertAction!) in
                    // ...
            }
            alertController.addAction(OKAction)
        
            present(alertController, animated: true, completion:nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = studySession["name"] as? String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            dismiss(animated: true, completion: nil)
        }
    }
    

}
