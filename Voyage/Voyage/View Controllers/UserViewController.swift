//
//  UserViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/28/21.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userDescription: UILabel!
    
    @IBOutlet weak var contact: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var service: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    // Create the Person subclass that stores information about the user
    class Person {
        var name: String!
        var profileImage: UIImage!
        var description: String!
        var contact: String!
        var location: String!
        var isSeller: Bool!
        var service: String!
        var price: String!
    }
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create rounded profile image
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.contentMode = .scaleAspectFill
        
        // Set the uilabels to retrieved values
        self.name.text = person.name
        self.profileImage.image = person.profileImage
        self.userDescription.text = person.description
        
        if person.isSeller {
            // Also set the contact, location, service, and price if the user is a seller
            if person.contact != "No phone number available" {
                self.contact.text = Utilities.formatPhoneNumber(person.contact)
            } else {
                self.contact.text = person.contact
            }
            self.location.text = person.location
            self.service.text = person.service
            self.price.text = "$" + person.price
        } else {
            // Remove uilabels if they are not a seller
            self.contact.removeFromSuperview()
            self.location.removeFromSuperview()
            self.service.removeFromSuperview()
            self.price.removeFromSuperview()
        }

        // Do any additional setup after loading the view.
    }

}
