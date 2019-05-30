//
//  SignUpViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/27/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//


// Need to change the structure of the database
import UIKit
import RealmSwift
import Foundation
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    // Fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Process the image
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        
        // Process the button
        imageButton.layer.borderWidth = 1.0
        imageButton.layer.masksToBounds = false
        imageButton.layer.cornerRadius = imageButton.frame.size.width / 2
        imageButton.clipsToBounds = true
        
        // Release the keyboard when tapping around
        self.hideKeyboardWhenTappedAround()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if (emailField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if (firstNameField.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter your first name.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else if (lastNameField.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter your last name.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else if (phoneNumber.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please enter your phone number.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else if (password.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            // Good to sign up
            Auth.auth().createUser(withEmail: emailField.text!, password: password.text!) { (authresult, error) in
                
                if (error != nil){
                    // there is an error
                } else {
                    self.performSegue(withIdentifier: "success", sender: self)
                }
            }
            
        }
       
    }
}

// Extend the UIViewController and hide the keyboard whenever the user taps around
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

