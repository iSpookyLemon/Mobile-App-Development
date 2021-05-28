//
//  SellerViewController.swift
//  Voyage
//
//  Created by Shivam Kumar on 5/26/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

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
    
    @IBOutlet weak var errorLabel: UILabel!
    
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
            
            uploadImage(image)
        }
        else
        {
            //error message
        }
        
        self.dismiss(animated:true, completion:nil)
    }
    
    func uploadImage(_ image: UIImage) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/image.jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imageRef.putData(image.jpegData(compressionQuality: 0.5)!, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }
    
    @IBOutlet weak var signUpServiceButton: UIButton!
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.invertedStyleTextField(freelanceServiceTextField)
        Utilities.invertedStyleTextField(dollarsPerHourTextField)
        Utilities.invertedStyleTextField(phoneNumberTextField)
        Utilities.invertedStyleFilledButton(signUpServiceButton)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwide, it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if freelanceServiceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dollarsPerHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Cheak if the password is secure
        let cleanedPhoneNumber = phoneNumberTextField.text!
        
        if Utilities.isPhoneNumberValid(cleanedPhoneNumber) == false {
            //PhoneNumber is'nt secure enough
            return "Please Recheck your Phone Number"
        }
        
        return nil
    }
    
    @IBAction func signUpSellerTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            
            showError(error!)
            
        }
        //PUT AN ELSE
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
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
