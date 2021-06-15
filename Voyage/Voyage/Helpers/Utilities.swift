//
//  Utilities.swift
//
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func invertedStyleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 135/255, blue: 6/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func invertedStyleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 255/255, green: 135/255, blue: 6/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        // Test the strength of the password
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //check if the phoneNumber the user entered is valid
    static func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
        
        //check if the phone number consists of only numbers
        let phoneNumberIsAllNumber = phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        
        //check if the phone number consists of exactly 10 numbers and if both are right, then return true
        if phoneNumber.count==10 && phoneNumberIsAllNumber{
            return true
        }
        else{
            //if one of the above parameters are wrong, return false
            return false
        }
        
        
    }
    
    //check if the wage the user entered is valid
    static func isDollarsPerHourValid(_ dollarsPerHour: String) -> Bool {
        
        //check if the wage the user entered consists of only numbers
        let dollarsPerHourIsAllNumber = dollarsPerHour.rangeOfCharacter(from:CharacterSet.decimalDigits.inverted) == nil
        
        if dollarsPerHourIsAllNumber{
            
            //If the wage is only numbers, return true
            return true
        }
        else {
            //if the wage is not only numbers, return false
            return false
        }
        
    }
    
    static func formatPhoneNumber(_ phoneNumber: String) -> String{
        let s = phoneNumber
        
        // String manipulation to format the phone number correctly
        let formattedPhoneNumber = String(format: "(%@) %@-%@", String(s[...s.index(s.startIndex, offsetBy: 2)]), String(s[s.index(s.startIndex, offsetBy: 3)...s.index(s.startIndex, offsetBy: 5)]), String(s[s.index(s.startIndex, offsetBy: 6)...s.index(s.startIndex, offsetBy: 9)]))
        return formattedPhoneNumber
    }
    
    //function to check if the user is a seller
    static func checkIfSeller() -> Bool{
        
        let uid = Auth.auth().currentUser!.uid
    
        //Create a firestore object
        let db = Firestore.firestore()
        
        //Access the data of current user
        let docRef = db.collection("users").document(uid)
        
        var isSeller = false
        
        //Check the variable of "isSeller" in the firebase database
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{

                isSeller = document.get("isSeller") as? Bool ?? false
            
                
            }
            
        }
        
        //return the answer
        return isSeller
    }
    
}
