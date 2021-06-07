//
//  SettingsViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 6/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOut: UIButton!
    
    @IBOutlet weak var deleteSellerAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let uid = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{

                let isSeller = document.get("isSeller") as? Bool
        
                let wasOnceSeller = document.get("wasOnceSeller") as? Bool
                
                if isSeller == false {
                    
                    self.deleteSellerAccountButton.removeFromSuperview()
                    
                }
                
                if isSeller == true {
                    
                    self.view.addSubview(self.deleteSellerAccountButton)
                    
                }
                
                
            }
        }
    }
    

    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func deleteSellerAccountTapped(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        db.collection("users").document("Auth.auth().currentUser!.uid").updateData([
            "freelanceService": FieldValue.delete(), "dollarsPerHour": FieldValue.delete(),
            "phoneNumber": FieldValue.delete(), "isSeller": false, "wasOnceSeller": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

        
    }
    
    
}
