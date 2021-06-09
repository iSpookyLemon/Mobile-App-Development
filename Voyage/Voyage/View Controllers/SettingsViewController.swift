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

    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var changeProfilePictureButton: UIButton!
    
    @IBOutlet weak var changeProfileNameTextField: UITextField!
    
    @IBOutlet weak var changeFreelanceServiceTextField: UITextField!
    
    @IBOutlet weak var changeWageTextField: UITextField!
    
    @IBOutlet weak var changePhoneNumberTextField: UITextField!
    
    @IBOutlet weak var changeUserDescriptionTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UIStackView!
    
    @IBOutlet weak var changeProfileButton: UIButton!
    
    @IBOutlet weak var signOut: UIButton!
    
    @IBOutlet weak var deleteSellerAccountButton: UIButton!
    
    @IBOutlet weak var deleteFillAccountButton: UIButton!
    
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
        
        let alert = UIAlertController(title: "Are you sure you want to Delete your Seller Account?", message: "This will remove all seller related information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in

            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "freelanceService": FieldValue.delete(), "dollarsPerHour": FieldValue.delete(),
                "phoneNumber": FieldValue.delete(), "isSeller": false, "wasOnceSeller": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            self.viewDidLoad()
            
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteFullAccountTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to Delete your Full Account?", message: "This will remove all information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).delete()
            
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            self.transitionToVC()
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func transitionToVC() {
        
        let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
