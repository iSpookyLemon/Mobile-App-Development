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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
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
