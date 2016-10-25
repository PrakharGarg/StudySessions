//
//  CoursesTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 10/22/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    
    @IBOutlet var courseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
