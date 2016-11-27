//
//  ViewFileTableViewCell.swift
//  StudySessions
//
//  Created by Prakhar Garg on 11/10/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

protocol ViewFileTableViewCellDelegate: class {
    func goToFile(with cell: ViewFileTableViewCell)
}

class ViewFileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageFileView: UIImageView!
    weak var delegate: ViewFileTableViewCellDelegate?
    
    @IBAction func viewFileLargeBtn(_ sender: Any) {
        delegate?.goToFile(with: self)
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
