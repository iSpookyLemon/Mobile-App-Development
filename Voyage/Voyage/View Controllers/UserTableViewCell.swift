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
    
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create rounded profile image
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.contentMode = .scaleAspectFill
        // Initialization code
    }

}
