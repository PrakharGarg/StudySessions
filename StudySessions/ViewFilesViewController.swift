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
    
    @IBOutlet weak var tableView: UITableView!
    
    // Variable that holds all of the files for the current study session
    var imageArray = [UIImage]()
    
    var studySession: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the keyboard
        hideKeyboardWhenTappedAround()
        // Set the title of the view controller
        self.title = "Study Session Files"
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
//        let imageDataArray = studySession?["files"] as! [NSData]
//        if imageDataArray != nil {
//            for imageData in imageDataArray {
//                let image = UIImage(data: imageData as Data)
//                self.imageArray.append(image!)
//            }
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    // Create cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleFile", for: indexPath) as! ViewFileTableViewCell
        let file = self.imageArray[indexPath.row]
        
        cell.fileImageView.image = file
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFiles") {
            let destination = segue.destination as! ViewFilesViewController
            destination.studySession = self.studySession as PFObject
        }
    }

    

}
