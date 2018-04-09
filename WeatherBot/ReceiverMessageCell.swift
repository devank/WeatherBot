//
//  ReceiverMessageCell.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Devan K. All rights reserved.
//

import UIKit

class ReceiverMessageCell: UITableViewCell {
    
    @IBOutlet weak var receiverMessageLabel: PaddedLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
