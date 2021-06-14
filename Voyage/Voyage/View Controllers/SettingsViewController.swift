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
        
        self.scrollView.addSubview(changeAccountInfoVertialStackView)
        self.changeAccountInfoVertialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.changeAccountInfoVertialStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.changeAccountInfoVertialStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.changeAccountInfoVertialStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.changeAccountInfoVertialStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        self.changeAccountInfoVertialStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
       
        Utilities.invertedStyleFilledButton(changeProfileButton)
        
        let uid = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{

                let isSeller = document.get("isSeller") as? Bool
        
                let wasOnceSeller = document.get("wasOnceSeller") as? Bool
                
                
                if isSeller == false {
                    
                    self.deleteSellerAccountButton.removeFromSuperview()
                    self.changeFreelanceServiceTextField.removeFromSuperview()
                    self.changeWageTextField.removeFromSuperview()
                    self.changePhoneNumberTextField.removeFromSuperview()
                    
                }
                
                if isSeller == true {
                    
                    
                    
                    self.deleteAccountsVerticalStackView.addSubview(self.deleteSellerAccountButton)
                    self.changeAccountInfoVertialStackView.addSubview(self.changeFreelanceServiceTextField)
                    self.changeAccountInfoVertialStackView.addSubview(self.changeWageTextField)
                    self.changeAccountInfoVertialStackView.addSubview(self.changePhoneNumberTextField)
                    
                }
                
                self.errorLabel.alpha = 0
                
            }
        }
    }
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        
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
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.contentMode = .scaleAspectFill
            self.profileImage.image = image
            
        }
        else
        {
            //error message
        }
        
        self.dismiss(animated:true, completion:nil)
    }


    @IBAction func applyChangesToProfileTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            
            showError(error!)
            
        }
        
        else{
            
            let uid = Auth.auth().currentUser!.uid
            
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(uid)
            
            if profileImage.image != UIImage(systemName: "person.circle") {
                uploadImage(profileImage.image!)
            }
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists{

                    let isSeller = document.get("isSeller") as? Bool
            
                    let profileName = self.changeProfileNameTextField.text!
            
                    if let text = self.changeProfileNameTextField.text, text.isEmpty == false {

                        let nameArray = profileName.components(separatedBy: " ")
                        
                        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["firstname": nameArray[0], "lastname": nameArray[1], "fullnamelower":profileName.lowercased()], merge:true) { (error) in
                    
                            if error != nil {
                        // Show error message
                                self.showError("Error saving user data")
                            }
                        }
                
                    }
                    if let location = self.changeLocationTextField.text, location.isEmpty == false {
                        db.collection("users").document(Auth.auth().currentUser!.uid).setData(["location": location, "locationlower": location.lowercased()], merge:true) { (error) in
                    
                            if error != nil {
                        // Show error message
                                self.showError("Error saving user data")
                            }
                        }
                
                    }
            
                    if isSeller == true{
            
                        let freelanceService = self.changeFreelanceServiceTextField.text!
                        let wage = self.changeWageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        let phoneNumber = self.changePhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if let text = self.changeFreelanceServiceTextField.text, text.isEmpty == false{
                            
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(["freelanceService":freelanceService, "freelanceServiceLower": freelanceService.lowercased()], merge:true) { (error) in
                    
                                if error != nil {
                        // Show error message
                                    self.showError("Error saving user data")
                                }
                            }
                
                        }
            
                        if let text = self.changeWageTextField.text, text.isEmpty == false{
                            
                            db.collection("users").document(Auth.auth().currentUser!.uid).setData(  ["dollarsPerHour":wage], merge:true) { (error) in
                    
                                if error != nil {
                                    // Show error message
                                    self.showError("Error saving user data")
                                }
                            }
                
                        }
            
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
            
            let userDescription = self.changeUserDescriptionTextField.text!
            
            if let text = self.changeUserDescriptionTextField.text, text.isEmpty == false {

                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["description":userDescription], merge:true) { (error) in
                    if error != nil {
                        // Show error message
                        self.showError("Error saving user data")
                    }
                }
                
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
            try Auth.auth().signOut()
            let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
            
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func deleteSellerAccountTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to Delete your Seller Account?", message: "This will remove all seller related information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in

            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "freelanceService": FieldValue.delete(), "dollarsPerHour": FieldValue.delete(),
                "phoneNumber": FieldValue.delete(), "isSeller": false, "wasOnceSeller": true
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            self.viewDidLoad()
            
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteFullAccountTapped(_ sender: Any) {
        

        
        let alert = UIAlertController(title: "Are you sure you want to Delete your Full Account?", message: "This will remove all information of yours from Voyage.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            let db = Firestore.firestore()
            
            db.collection("users").document(Auth.auth().currentUser!.uid).delete()
            
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
                self.transitionToVC()
            }
            
        }))
        


        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            

            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func transitionToVC() {
        
        let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        
        
        
        if Utilities.checkIfSeller() == true {
                    
            let cleanedPhoneNumber = self.changePhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
            if let text = self.changePhoneNumberTextField.text, text.isEmpty{
                    
                if Utilities.isPhoneNumberValid(cleanedPhoneNumber) == false {
                        
                    return "Make sure your new phone number is only numbers (No Hyphens)"
                        
                }
            }
                
            let cleanedWage = self.changeWageTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
                    
            if let text = self.changeWageTextField.text, text.isEmpty{
                    
                if Utilities.isDollarsPerHourValid(cleanedWage) == false{
                        
                    return "Make sure your dollars per hour is only numbers"
                        
                }
                    
            }
        }
        
        return nil
    }
}


