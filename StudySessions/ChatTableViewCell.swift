//
//  ChatTableViewCell.swift
//  StudySessions
//
//  Created by Naren Inukoti on 11/10/16.
//  Copyright © 2016 Group2. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
