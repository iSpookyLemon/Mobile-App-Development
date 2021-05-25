//
//  FeedViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/24/21.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let db = Firestore.firestore()
        let searchString = searchBar.text!.lowercased()
        
        if searchString != "" {
            db.collection("users")
                .whereField("fullnamelower", isLessThanOrEqualTo: searchString + "\u{f8ff}")
                .whereField("fullnamelower", isGreaterThanOrEqualTo: searchString)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
            }
        }
    }
    
}
