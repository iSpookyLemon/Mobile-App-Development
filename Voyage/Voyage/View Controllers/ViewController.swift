//
//  ViewController.swift
//  sample1
//
//  Created by Kevin K. Li on 5/17/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the elements
        setUpElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if user is signed in
        if Auth.auth().currentUser != nil {
            // Automatically go to home screen if the user is signed in
            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
        
    }


    func setUpElements() {
        
        // Style the buttons
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
}

