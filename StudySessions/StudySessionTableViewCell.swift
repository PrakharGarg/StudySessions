//
//  StudySessionTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/8/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

class StudySessionTableViewCell: UITableViewCell, UIPopoverPresentationControllerDelegate {

    @IBOutlet var title_time: UILabel!
    
    @IBOutlet var className: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
