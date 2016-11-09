//
//  StudySessionTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

protocol StudySessionTableViewCellDelegate: class {
    func goToSession(with cell: StudySessionTableViewCell)
}

class StudySessionTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    
    var studySession = [PFObject]()

    @IBOutlet var title_time: UILabel!
    
    @IBOutlet var className: UILabel!
    
    @IBOutlet var studySessionButtonLabel: UIButton!
    
    weak var delegate: StudySessionTableViewCellDelegate?
    
    let userId = (PFUser.current()?.objectId)!
    
    // When the user clicks on the button
    @IBAction func studySessionButton(_ sender: Any) {
        // If the user hasn't joined the class, let them join
        if studySessionButtonLabel.titleLabel?.text == "Join" {
            
            let study_session = studySession.first!
            
            let query = PFQuery(className:"StudySessions")
            query.whereKey("objectId", equalTo: (study_session.objectId)!)
            query.findObjectsInBackground { (session: [PFObject]?, error: Error?) in
                if error == nil {
                    let tempSession = session?.first
                    // Add the current student to the Study Session model.
                    tempSession?.addUniqueObjects(from: [self.userId], forKey: "students")
                    tempSession?.saveInBackground()
                    
                    (self.superview?.superview as! UITableView).reloadData()
                    
                }
            }

        } else {
            delegate?.goToSession(with: self)
        }
        // The button == -> and we need to segue to the Study Session page.
        
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
