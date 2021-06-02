//
//  SettingsViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 6/1/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
