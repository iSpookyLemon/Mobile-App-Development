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
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.contentMode = .scaleAspectFill
        
        self.name.text = person.name
        self.profileImage.image = person.profileImage
        self.userDescription.text = person.description
        if person.isSeller {
            if person.contact != "No phone number available" {
                self.contact.text = Utilities.formatPhoneNumber(person.contact)
            } else {
                self.contact.text = person.contact
            }
            self.location.text = person.location
            self.service.text = person.service
            self.price.text = "$" + person.price
        } else {
            self.contact.removeFromSuperview()
            self.location.removeFromSuperview()
            self.service.removeFromSuperview()
            self.price.removeFromSuperview()
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
