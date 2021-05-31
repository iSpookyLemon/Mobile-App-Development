//
//  UserViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/28/21.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    var nameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = self.nameText

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
