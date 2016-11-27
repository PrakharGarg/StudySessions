//
//  ViewFilesViewController.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/10/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class ViewFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var studySession: PFObject!
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Find all of the courses for the current user
        loadFiles()
        // Allow users to refresh the page if the pull down
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
    }
    
    // Refresh on View
    override func viewWillAppear(_ animated: Bool) {
        loadFiles()
    }
    // Refresh function
    func refresh(refreshControl: UIRefreshControl) {
        loadFiles()
        refreshControl.endRefreshing()
    }
    
    func loadFiles() {
        //make sure imageFiles is empty
//        imageFiles.removeAll(keepingCapacity: false)
        let query = PFQuery(className: "StudySessions")
        query.getObjectInBackground(withId: studySession.objectId!, block: { (object: PFObject?, error: Error?) in
            if error == nil {
                if let allImageFiles = object?.value(forKey: "files") as? [PFFile]!{
                    if allImageFiles == nil {
                        self.imageFiles = [PFFile]()
                        self.tableView.reloadData()
                    } else {
                        for imageFile in allImageFiles {
                            self.imageFiles.append(imageFile)
                            self.tableView.reloadData()
                        }
                    }
                }
            }

        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageFiles.count
    }
    
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleFile", for: indexPath) as! ViewFileTableViewCell
        self.imageFiles[indexPath.row].getDataInBackground { (imageData: Data?, error: Error?) in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.fileImageView.image = image!
                print("The loaded image: \(image)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAddNewFile") {
            let destination = segue.destination as! AddNewFileViewController
            destination.studySession = self.studySession
        }
    }

}
