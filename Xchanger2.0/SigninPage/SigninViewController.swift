//
//  SigninViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/26/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import Firebase


var appUserID = ""
var appProfilePicture = UIImage()
var appGithubURL = String()
var appInstagramURL = String()
var appQRCode = UIImage()
var appUserName = String()
var appEmail = String()
var appPhoneNumber = String()


class SigninViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
    }

//  Trying to set a background opague image
//    @IBOutlet weak var background: UIImageView!
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"Illustration1.png"]];
//    UIImageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if (emailField.text!.isValidEmail()){ // Check whether the email is valid
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                // Check whether the user exists in Firebase
                

                if (error != nil){
                    // Login failed
                    let alert = UIAlertController(title: "Login Failed!", message: "Check your email and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: nil))
                    
                    // Present the alert
                    self.present(alert, animated: true)
                } else {
                    let currentUser = Auth.auth().currentUser!.uid
                    if (appUserID == "" || appUserID != currentUser){
                        // Update the user id
                        appUserID = currentUser
                        
                        let refName = Database.database().reference().root.child("full_names").child(appUserID)
                        
                        refName.observeSingleEvent(of: .value, with: { (snapshot) in
                            let name = snapshot.value as? String
                            if let fullName = name {
                                appUserName = fullName
                            }
                            self.performSegue(withIdentifier: "loginSuccess", sender: self)
                        })
                    }
                    
                    // Succeeded so proceed
                    
                }
            }
        } else {
            //the email is invalid
            //set up the alert
            let alert = UIAlertController(title: "Login Failed!", message: "Email is invalid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            //present the alert to the user
            self.present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SignUpViewController
        {
            if let vc = segue.destination as? SignUpViewController{
                vc.email = emailField.text!
                vc.password = passwordField.text!
            }
        }
    }
}


extension String {
    //checks whether the given email is valid
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
