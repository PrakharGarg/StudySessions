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
        //Saves to camera roll
        if imageView.image == nil {
            //Alerts user and returns to View Files view
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
            let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
            let compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
            //Saves to study session files
        
            //Alerts user and returns to View Files view
            let alertController = UIAlertController(
                title: "Yay!",
                message: "File has successfully been added.",
                preferredStyle: .alert
            )
        
            let OKAction = UIAlertAction(
                title: "Okay", style: .default) { (action:UIAlertAction!) in
                    self.performSegue(withIdentifier: "returnToViewFiles", sender: self)
            }
            alertController.addAction(OKAction)
        
            present(alertController, animated: true, completion:nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
