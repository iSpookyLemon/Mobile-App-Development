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
    
    var didUploadImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create rounded profile images
        self.importImageImageView.layer.cornerRadius = self.importImageImageView.frame.width / 2
        self.importImageImageView.contentMode = .scaleAspectFill

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    // introduce all needed elements as variables
    
    @IBOutlet weak var freelanceServiceTextField: UITextField!
    
    @IBOutlet weak var dollarsPerHourTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var importImageImageView: UIImageView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func importImageButton(_ sender: Any) {
        //accesses the UIImagePicker
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated:true){
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Create a firestore object
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid
        
        // query for the current user
        db.collection("users").document(uid).getDocument() { (document, error) in
            if error == nil {
                let wasOnceSeller = document!.get("wasOnceSeller") as? Bool ?? false
                if wasOnceSeller == true {
                    // if the user was once a seller, they did upload an image
                    self.didUploadImage = true
                }
            }
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            //replace the placeholder image with the image the user chose
            importImageImageView.image = image
            didUploadImage = true
            
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
        
        // Check if the image size is less than some size
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
        
        // hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.invertedStyleTextField(freelanceServiceTextField)
        Utilities.invertedStyleTextField(dollarsPerHourTextField)
        Utilities.invertedStyleTextField(phoneNumberTextField)
        Utilities.invertedStyleFilledButton(signUpServiceButton)
        Utilities.invertedStyleTextField(locationTextField)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwide, it returns the error message
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if freelanceServiceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dollarsPerHourTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            locationTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields."
        }
        
        //Cheak if the password is secure
        let cleanedPhoneNumber = phoneNumberTextField.text!
        
        if Utilities.isPhoneNumberValid(cleanedPhoneNumber) == false {
            //PhoneNumber is'nt valid
            return "Make sure your phone number is only numbers (No Hyphens)"
        }
        
        let cleanedDollarsPerHour = dollarsPerHourTextField.text!
        
        if Utilities.isDollarsPerHourValid(cleanedDollarsPerHour) == false {
            // price is not a valid number
            return "Make sure your dollars per hour is only numbers"
            
        }
        
        if didUploadImage == false{
            // user did not upload an image
            return "Please choose a profile image"
            
        }
        
        return nil
    }
    
    @IBAction func signUpSellerTapped(_ sender: Any) {
        
        // check if all fields are validated
        let error = validateFields()
        
        if error != nil{
            // show error
            showError(error!)
            
        }
        
        else{
            
            
            // Create cleaned verssions of the data
            let freelanceService = freelanceServiceTextField.text!
            let dollarsPerHour = dollarsPerHourTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationTextField.text!
                    
            // Create a firestore object
            let db = Firestore.firestore()

            // Query for data of current user
            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["isSeller":true, "freelanceService":freelanceService, "freelanceServiceLower": freelanceService.lowercased(), "dollarsPerHour":dollarsPerHour, "phoneNumber":phoneNumber,"wasOnceSeller":false, "location":location, "locationlower":location.lowercased()], merge: true) { (error) in
                        
                    if error != nil {
                        // Show error message
                        self.showError("Error saving user data")
                    }
                }
            
            // upload the user's image to firebase storage
            uploadImage(importImageImageView.image!) {
                self.transitionToHome()
            }
        }
    }
    
    func showError(_ message:String) {
        // Show error
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        // transition to home screen
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        
        view.window?.makeKeyAndVisible()
        
    }
    
}
