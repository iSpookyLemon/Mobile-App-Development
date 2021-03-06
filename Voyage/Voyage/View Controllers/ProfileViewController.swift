//
//  ProfileViewController.swift
//  Voyage
//
//  Created by Shivam Kumar on 5/26/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var freelanceServiceLabel: UILabel!
    
    @IBOutlet weak var dollarsPerHourLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var userDescription: UILabel!
    
    @IBOutlet weak var sellerButton: UIButton!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var verticalStack: UIStackView!
    
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get user id of current user
        let uid = Auth.auth().currentUser!.uid
        
        // Create firestore object
        let db = Firestore.firestore()
        
        // Create a reference to the user in firestore
        let docRef = db.collection("users").document(uid)
        
        // Make profile image rounded
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.contentMode = .scaleAspectFill
        
        // download the profile image of the user
        downloadImage(uid) {
            // set the image to the downloaded image on screen
            self.profileImage.image = self.image
        }
        
        // get data from the reference
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                // get boolean values about seller status
                let isSeller = document.get("isSeller") as? Bool
                let wasOnceSeller = document.get("wasOnceSeller") as? Bool
            
                if isSeller == true && wasOnceSeller == false{
                    
                    // Delete become a seller and add new constraint
                    self.sellerButton.removeFromSuperview()
                    
                    for constraint in self.view.constraints{
                        
                        if constraint.identifier == "profileVCVerticalConstraint"{
                            
                            constraint.constant = 20
                        }
                    }
                }
                
                if isSeller == false && wasOnceSeller == true {
                    
                    // Add back "Become a Seller" if user decides to delete their seller account and revert constraints
                    
                    self.view.addSubview(self.sellerButton)
                    
                    for constraint in self.view.constraints{
                        
                        if constraint.identifier == "profileVCVerticalConstraint"{
                            
                            constraint.constant = 75
                        }
                    }
                    
                }
                
                if isSeller == false{
                    
                    //remove fields related only to sellers
                    
                    self.freelanceServiceLabel.removeFromSuperview()
                    self.dollarsPerHourLabel.removeFromSuperview()
                    self.phoneNumberLabel.removeFromSuperview()
                    self.locationLabel.removeFromSuperview()
                    
                }
                
                if isSeller == true{
                    
                    // add back fields related only to sellers if seller decides to delete seller account
                    
                    self.verticalStack.addSubview(self.freelanceServiceLabel)
                    self.verticalStack.addSubview(self.dollarsPerHourLabel)
                    self.verticalStack.addSubview(self.phoneNumberLabel)
                    self.verticalStack.addSubview(self.locationLabel)
                    
                }
                
                //obtain information of the user from the database and store them in variables
                
                let firstName = document.get("firstname") as? String ?? "Error"
                let lastName = document.get("lastname") as? String ?? "Error"
                let description = document.get("description") as? String ?? "Hello, my name is " + firstName + " " + lastName
                let freelanceService = document.get("freelanceService") as? String ?? "Error"
                let dollarsPerHour = document.get("dollarsPerHour") as? String ?? "Error"
                let phoneNumber = document.get("phoneNumber") as? String ?? "Error"
                let location = document.get("location") as? String ?? "Error"
                
                
                // Set all text fields to users information in place of placeholders
                
                self.name.text = firstName + " " + lastName
                self.freelanceServiceLabel.text = freelanceService
                self.dollarsPerHourLabel.text = "$" + dollarsPerHour
                // Check if you have a phone number
                if phoneNumber != "Error" {
                    self.phoneNumberLabel.text = Utilities.formatPhoneNumber(phoneNumber)
                } else {
                    self.phoneNumberLabel.text = phoneNumber
                }
                self.locationLabel.text = location
                self.userDescription.text = description
            } else {
                print("Document does not exist")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func downloadImage(_ uid: String, completion: @escaping () -> Void){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child(uid + "/profile.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error != nil {
                // The user either does not have an image or an error occured, so the default image shows
                self.image = UIImage(systemName: "person.circle")
            } else {
                // Data is returned
                self.image = UIImage(data: data!)
            }
            completion()
        }
    }

}
