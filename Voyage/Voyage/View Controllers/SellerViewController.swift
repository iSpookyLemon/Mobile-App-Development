//
//  SellerViewController.swift
//  Voyage
//
//  Created by Shivam Kumar on 5/26/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SellerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userImage = UIImage()
    
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
            userImage = image
            
        }
        else
        {
            //error message
        }
        
        self.dismiss(animated:true, completion:nil)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping () -> Void) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let uid = Auth.auth().currentUser!.uid
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child(uid + "/profile.jpg")

        let image = image.jpegData(compressionQuality: 0.5)!
        
        if image.count <= 2 * 1024 * 1024 {
            // Upload the file to the path "images/rivers.jpg"
            imageRef.putData(image, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred
                    completion()
                    return
                }
                completion()
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
            return "Make sure your phone number is only numbers (No Hyphens)"
        }
        
        let cleanedDollarsPerHour = dollarsPerHourTextField.text!
        
        if Utilities.isDollarsPerHourValid(cleanedDollarsPerHour) == false {
            
            return "Make sure your dollars per hour is only numbers"
            
        }
        
        return nil
    }
    
    @IBAction func signUpSellerTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            
            showError(error!)
            
        }
        
        else{
            
            
            // Create cleaned verssions of the data
            let freelanceService = freelanceServiceTextField.text!
            let dollarsPerHour = dollarsPerHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // User was created successfully, now store the first name and last name
                let db = Firestore.firestore()

            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["isSeller":true, "freelanceService":freelanceService, "freelanceServiceLower": freelanceService.lowercased(), "dollarsPerHour":dollarsPerHour, "phoneNumber":phoneNumber,"wasOnceSeller":false], merge: true) { (error) in
                        
                    if error != nil {
                            // Show error message
                        self.showError("Error saving user data")
                    }
                }
            
            uploadImage(userImage) {
                self.transitionToHome()
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        
        view.window?.makeKeyAndVisible()
        
    }
    
}
