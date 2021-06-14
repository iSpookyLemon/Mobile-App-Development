//
//  BugViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 6/13/21.
//

import UIKit
import FirebaseFirestore

class BugViewController: UIViewController {
    
    @IBOutlet weak var bugDescription: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the view
        let borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.85)
        
        self.bugDescription.layer.borderWidth = 0.1
        self.bugDescription.layer.cornerRadius = 8;
        self.bugDescription.layer.borderColor = borderColor.cgColor
        
    }
    

    @IBAction func submitButtonTapped(_ sender: Any) {
        // Create a firestore object
        let db = Firestore.firestore()

        // add a document to the "bugs" collection
        db.collection("bugs").addDocument(data: ["bug": bugDescription.text!]) { (error) in
            
            if error != nil {
                // Show error message
               print("Error saving user data")
            }
        }
    }

}
