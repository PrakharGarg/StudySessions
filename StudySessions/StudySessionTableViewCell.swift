//
//  StudySessionTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

class StudySessionTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    var studySession = [PFObject]()

    @IBOutlet var title_time: UILabel!
    
    @IBOutlet var className: UILabel!
    
    @IBOutlet var studySessionButtonLabel: UIButton!
    
    let userId = (PFUser.current()?.objectId)!
    
    @IBAction func studySessionButton(_ sender: Any) {
        
        if studySessionButtonLabel.titleLabel?.text == "Join" {
            
            let study_session = studySession.first!
            
            let query = PFQuery(className:"StudySessions")
            
            query.whereKey("objectId", equalTo: (study_session.objectId)!)
            query.findObjectsInBackground { (session: [PFObject]?, error: Error?) in
                if error == nil {
                    let tempSession = session?.first
                    tempSession?.addUniqueObjects(from: [self.userId], forKey: "students")
                    tempSession?.saveInBackground()
                    
                    (self.superview?.superview as! UITableView).reloadData()
                    
                }
            }

        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
