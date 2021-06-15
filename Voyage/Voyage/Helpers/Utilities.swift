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
    
    static func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
        
        let phoneNumberIsAllNumber = phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        
        if phoneNumber.count==10 && phoneNumberIsAllNumber{
            return true
        }
        else{
            return false
        }
        
        
    }
    
    static func isDollarsPerHourValid(_ dollarsPerHour: String) -> Bool {
        
        let dollarsPerHourIsAllNumber = dollarsPerHour.rangeOfCharacter(from:CharacterSet.decimalDigits.inverted) == nil
        
        if dollarsPerHourIsAllNumber{
            return true
        }
        else {
            return false
        }
        
    }
    
    static func formatPhoneNumber(_ phoneNumber: String) -> String{
        let s = phoneNumber
        
        // String manipulation to format the phone number correctly
        let formattedPhoneNumber = String(format: "(%@) %@-%@", String(s[...s.index(s.startIndex, offsetBy: 2)]), String(s[s.index(s.startIndex, offsetBy: 3)...s.index(s.startIndex, offsetBy: 5)]), String(s[s.index(s.startIndex, offsetBy: 6)...s.index(s.startIndex, offsetBy: 9)]))
        return formattedPhoneNumber
    }
    
    static func checkIfSeller() -> Bool{
        
        let uid = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        
        var isSeller = false
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{

                isSeller = document.get("isSeller") as? Bool ?? false
            
                
            }
            
        }
        print (isSeller)
        return isSeller
    }
    
}
