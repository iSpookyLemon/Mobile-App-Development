//
//  SellerViewController.swift
//  Voyage
//
//  Created by Shivam Kumar on 5/26/21.
//

import UIKit
import FirebaseAuth

class SellerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    @IBOutlet weak var freelanceServiceTextField: UITextField!
    
    @IBOutlet weak var dollarsPerHourTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var importImageImageView: UIImageView!
    
    @IBAction func importImageButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated:true){
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            importImageImageView.image = image
        }
        else
        {
            //error message
        }
        
        self.dismiss(animated:true, completion:nil)
    }
    
    @IBOutlet weak var signUpServiceButton: UIButton!
    
    func setUpElements() {
        Utilities.invertedStyleTextField(freelanceServiceTextField)
        Utilities.invertedStyleTextField(dollarsPerHourTextField)
        Utilities.invertedStyleTextField(phoneNumberTextField)
        Utilities.invertedStyleFilledButton(signUpServiceButton)
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
