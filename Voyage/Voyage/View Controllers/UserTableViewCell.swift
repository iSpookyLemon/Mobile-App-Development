//
//  UserTableViewCell.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/26/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var service: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var contact: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
