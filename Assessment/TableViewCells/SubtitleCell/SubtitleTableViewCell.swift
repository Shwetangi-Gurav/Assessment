//
//  SubtitleTableViewCell.swift
//  Assessment
//
//  Created by SensiBolApple on 20/09/21.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {

    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var contentLen: UILabel!
    @IBOutlet weak var favIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
