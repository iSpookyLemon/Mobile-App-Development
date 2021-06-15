//
//  SettingsViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 6/1/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //introduce all needed elements as variables
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var changeProfilePictureButton: UIButton!
    
    @IBOutlet weak var changeProfileNameTextField: UITextField!
    
    @IBOutlet weak var changeLocationTextField: UITextField!
    
    @IBOutlet weak var changeFreelanceServiceTextField: UITextField!
    
    @IBOutlet weak var changeWageTextField: UITextField!
    
    @IBOutlet weak var changePhoneNumberTextField: UITextField!
    
    @IBOutlet weak var changeUserDescriptionTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var changeProfileButton: UIButton!
    
    @IBOutlet weak var signOut: UIButton!
    
    @IBOutlet weak var deleteSellerAccountButton: UIButton!
    
    @IBOutlet weak var deleteFillAccountButton: UIButton!
    
    @IBOutlet weak var changeAccountInfoVertialStackView: UIStackView!
    
    @IBOutlet weak var deleteAccountsVerticalStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the error label since there is not currently an error
        self.errorLabel.alpha = 0
        
        //Add the scroll view along with its constraints into the view controller
        
        self.scrollView.addSubview(changeAccountInfoVertialStackView)
        self.changeAccountInfoVertialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.changeAccountInfoVertialStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.changeAccountInfoVertialStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.changeAccountInfoVertialStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.changeAccountInfoVertialStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        self.changeAccountInfoVertialStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
       //Style elements
        
        Utilities.invertedStyleFilledButton(changeProfileButton)
        
        //Create a User Variable
        let uid = Auth.auth().currentUser!.uid
        
        //Create a firestore object
        let db = Firestore.firestore()
        
        //Access the data of current user
        let docRef = db.collection("users").document(uid)
        
        //Check and see if the user is currently a seller
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{

                let isSeller = document.get("isSeller") as? Bool
                
                
                if isSeller == false {
                    
                    //if the user is not a seller, delete all elements which are for sellers
                    self.deleteSellerAccountButton.removeFromSuperview()
                    self.changeFreelanceServiceTextField.removeFromSuperview()
                    self.changeWageTextField.removeFromSuperview()
                    self.changePhoneNumberTextField.removeFromSuperview()
                    self.changeLocationTextField.removeFromSuperview()
                    
                }
                
                if isSeller == true {
                    
                    //if the user creates a seller account, retrieve the elements which were once deleted
                    self.deleteAccountsVerticalStackView.addSubview(self.deleteSellerAccountButton)
                    self.changeAccountInfoVertialStackView.addSubview(self.changeFreelanceServiceTextField)
                    self.changeAccountInfoVertialStackView.addSubview(self.changeWageTextField)
                    self.changeAccountInfoVertialStackView.addSubview(self.changePhoneNumberTextField)
                    self.changeAccountInfoVertialStackView.addSubview(self.changeLocationTextField)
                    
                }
                
            }
        }
    }
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        //Accesses the UIImagePicker
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated:true){

        }
        
 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            // Create a rounded profile image in place of the placeholder image
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.image = image
            
        }
        else
        {
            //error message
            print("error")
        }
        
        self.dismiss(animated:true, completion:nil)
    }


    @IBAction func applyChangesToProfileTapped(_ sender: Any) {
        
        //Check if all fields are in the format which is asked for
        validateFields() { error in
        
            if error != nil{
                // if they are not in the correct format, instruct the user to change their input
                self.showError(error!)
                
            }
            
            else{
                
                
                //Create a user object
                let uid = Auth.auth().currentUser!.uid
                
                //Create a firestore object
                let db = Firestore.firestore()
                
                
                //Create a document reference from our document service
                let docRef = db.collection("users").document(uid)
                
                // if the user placed a new image, upload the image to the database
                if self.profileImage.image != UIImage(systemName: "person.circle") {
                    self.uploadImage(self.profileImage.image!)
                }
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists{
                        
                        // check if the user is a seller
                        let isSeller = document.get("isSeller") as? Bool
                        
                        // Set the new profile name if the user desires to change their profile name
                        let profileName = self.changeProfileNameTextField.text!
                
                        if let text = self.changeProfileNameTextField.text, text.isEmpty == false {
                            
                            // create an array the contains the full name in order to split it into first name and last name
                            let nameArray = profileName.components(separatedBy: " ")
                            
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["firstname": nameArray[0], "lastname": nameArray[1], "fullnamelower":profileName.lowercased()], merge:true) { (error) in
                        
                                if error != nil {
                            // Show error message
                                    self.showError("Error saving user data")
                                }
                            }
                    
                        }
                        
                        // if the user is a seller, allow them to change fields which are in the context of sellers
                        if isSeller == true{
                            
                            // Assign the text in each box to a variable
                            let freelanceService = self.changeFreelanceServiceTextField.text!
                            let wage = self.changeWageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let phoneNumber = self.changePhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            // if the user typed something in the location box, update the location of the user
                            if let location = self.changeLocationTextField.text, location.isEmpty == false {
                                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["location": location, "locationlower": location.lowercased()], merge:true) { (error) in
                            
                                    if error != nil {
                                        // Show error message
                                        self.showError("Error saving user data")
                                    }
                                }
                        
                            }
                            
                            // if the user typed something in the freelance service box, update the freelance service of the user
                            if let text = self.changeFreelanceServiceTextField.text, text.isEmpty == false{
                                
                                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["freelanceService":freelanceService, "freelanceServiceLower": freelanceService.lowercased()], merge:true) { (error) in
                        
                                    if error != nil {
                                        // Show error message
                                        self.showError("Error saving user data")
                                    }
                                }
                    
                            }
                            
                            // if the user typed something in the change Wage box, update the wage information of the user
                            if let text = self.changeWageTextField.text, text.isEmpty == false{
                                
                                db.collection("users").document(Auth.auth().currentUser!.uid).setData(  ["dollarsPerHour":wage], merge:true) { (error) in
                        
                                    if error != nil {
                                        // Show error message
                                        self.showError("Error saving user data")
                                    }
                                }
                    
                            }
                            
                            //if the user typed something in the phone Number box, update the phone Number of the user
                            if let text = self.changePhoneNumberTextField.text, text.isEmpty == false{
                                
                                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["phoneNumber":phoneNumber], merge:true) { (error) in
                        
                                    if error != nil {
                                        // Show error message
                                        self.showError("Error saving user data")
                                    }
                                }

                            }
                
                        }
                
                    }
                
                }
                
                
                // assign the text in the user Description box a variable
                let userDescription = self.changeUserDescriptionTextField.text!
                
                //if the user typed something in the user Description box, update the desiption of the user
                if let text = self.changeUserDescriptionTextField.text, text.isEmpty == false {

                    db.collection("users").document(Auth.auth().currentUser!.uid).setData(["description":userDescription], merge:true) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                }
                
                
                // transition back to the home view controller when done updating fields
                self.transitionToHomeVC()
                
            }
        }
        
    }
    
    func uploadImage(_ image: UIImage) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        let uid = Auth.auth().currentUser!.uid
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child(uid + "/profile.jpg")

        let image = image.jpegData(compressionQuality: 0.5)!
        
        // Check if image size is less than some size
        if image.count <= 2 * 1024 * 1024 {
            // Upload the file to the path "images/rivers.jpg"
            imageRef.putData(image, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred
                    return
                }
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            // try signing out
            try Auth.auth().signOut()
            
            // Transition to sign up/login screen
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            // Error signing out
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func deleteSellerAccountTapped(_ sender: Any) {
        
        
        //Alert the user of what will happen if the delete their seller account
        let alert = UIAlertController(title: "Are you sure you want to Delete your Seller Account?", message: "This will remove all seller related information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)
        //Give the user the option to proceed
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            // Create a firestore object
            let db = Firestore.firestore()
            //Delete all seller related fields in the firebase database
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "freelanceService": FieldValue.delete(), "freelanceServiceLower": FieldValue.delete(), "location": FieldValue.delete(), "locationlower": FieldValue.delete(), "dollarsPerHour": FieldValue.delete(),
                "phoneNumber": FieldValue.delete(), "isSeller": false, "wasOnceSeller": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            // Update the screen to show the non-seller POV
            self.viewDidLoad()
            
            //Transition to main VC
            self.transitionToVC()
            
        }))
        //Give the user the option to cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteFullAccountTapped(_ sender: Any) {
        

        //Alert the user of what will happen if the delete their whole account
        let alert = UIAlertController(title: "Are you sure you want to Delete your Full Account?", message: "This will remove all information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)
        
        // Give them the option to proceed
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            //Create a firestore object
            let db = Firestore.firestore()
            
            //Delete the users whole presence from our database
            db.collection("users").document(Auth.auth().currentUser!.uid).delete()
            
            // Dispatch Group is used to wait until user is deleted to transition back to sign up/login screen
            let group = DispatchGroup()
            
            group.enter()
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                // An error happened.
                    print(error!)
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                // transition back to sign up/login screen
                self.transitionToVC()
            }
            
        }))
        
        
        //give the user the option to cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            

            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func transitionToVC() {
        // Transition to login/sign up screen
        let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToHomeVC() {
        // Transitiont to home view controller
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    func showError(_ message:String) {
        // show error message
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields(completion: @escaping (String?) -> Void) {
        
        var error: String?
        
        //check if the objects we are about to work on exist in the POV of the user (Check if seller)
        Utilities.checkIfSeller() { isSeller in
            if isSeller {
            
                //define the text in the text field as a variable
                let cleanedPhoneNumber = self.changePhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                //Can only operate on the text field if text is not empty
                if let text = self.changePhoneNumberTextField.text, text.isEmpty{
                    //Only Needed the Else to see if the text is not empty
                }else{
                    
                    
                    //Check if the phone number is valid and in the correct format
                    if Utilities.isPhoneNumberValid(cleanedPhoneNumber) == false {
                            
                        error = "Make sure your new phone number is only numbers (No Hyphens)"
                            
                    }
                }
                
                
                //define the text in the text field as a variable
                let cleanedWage = self.changeWageTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
                
                //Can only operate on the text field if text is not empty
                if let text = self.changeWageTextField.text, text.isEmpty == false{
                    if Utilities.isDollarsPerHourValid(cleanedWage) == false{
                        error = "Make sure your dollars per hour is only numbers"
                            
                    }
                        
                }
            }
            completion(error)
        }
        
    }
}


