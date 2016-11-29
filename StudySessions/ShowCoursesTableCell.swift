//
//  ShowCoursesTableCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/27/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit
import Parse

protocol ShowCoursesTableCellDelegate: class {
    func goToSession(with cell: ShowCoursesTableCell)
}

class ShowCoursesTableCell: UITableViewCell {

    @IBOutlet weak var class_name: UILabel!
    weak var delegate: ShowCoursesTableCellDelegate?
    @IBAction func historyButton(_ sender: Any) {
        delegate?.goToSession(with: self)
    }
}
