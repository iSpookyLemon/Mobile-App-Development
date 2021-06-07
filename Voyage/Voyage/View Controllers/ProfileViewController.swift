//
//  ProfileViewController.swift
//  Voyage
//
//  Created by Shivam Kumar on 5/26/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var userDescription: UILabel!
    
    @IBOutlet weak var sellerButton: UIButton!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var verticalStack: UIStackView!
    
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
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
                    
                    self.view.addSubview(self.sellerButton)
                    
                    for constraint in self.view.constraints{
                        
                        if constraint.identifier == "profileVCVerticalConstraint"{
                            
                            constraint.constant = 75
                        }
                    }
                    
                }
                
                let firstName = document.get("firstname") as? String ?? ""
                let lastName = document.get("lastname") as? String ?? ""
                let description = document.get("description") as? String ?? "Hello, my name is " + firstName + " " + lastName
                
                self.name.text = firstName + " " + lastName
                self.userDescription.text = description
            } else {
                print("Document does not exist")
            }
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
