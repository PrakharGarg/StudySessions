//
//  CourseStudySessionTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/27/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

protocol CourseStudySessionTableViewCellDelegate: class {
    func goToSessions(with cell: CourseStudySessionTableViewCell)
}

class CourseStudySessionTableViewCell: UITableViewCell {
    
    var studySession = [PFObject]()
    
    @IBOutlet weak var title_time: UILabel!
    @IBOutlet weak var class_name: UILabel!

    
    weak var delegate: CourseStudySessionTableViewCellDelegate?

    @IBAction func arrowFunction(_ sender: Any) {
        delegate?.goToSessions(with: self)
    }
    
    
}
    



