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
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    var email:String = ""
//    var password:String = ""
    
    // Reference to the profile picture
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    // Fields
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
        
        // Process the passwordField field
        passwordField.isSecureTextEntry = true
        
        // Release the keyboard when tapping around
        self.hideKeyboardWhenTappedAround()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Pass email and passwordField data from login screen
//        emailField?.text = email
//        passwordField?.text = password
    }
    
    func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    @IBAction func pickImageButtonPressed(_ sender: Any) {
        
        // Allows the user to pick a picture from their library for the profile picture
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated:true, completion: nil)
        
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if (emailField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and passwordField.", preferredStyle: .alert)
            
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
        } else if (passwordField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            // Good to sign up
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authresult, error) in
                if (error != nil){
                    // there is an error
                } else {
                    
                    
                    let userID = Auth.auth().currentUser?.uid;//user id of the app
                    
                    appUserID = userID!
                    
                    // Update user information
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    
                    ref.child("full_names").child(Auth.auth().currentUser!.uid).setValue(self.firstNameField.text! + " " + self.lastNameField.text!)
                    
                    ref.child("phone_numbers").child(Auth.auth().currentUser!.uid).setValue(self.phoneNumber.text)
                    
                    
                        appPhoneNumber = self.phoneNumber.text!
                    ref.child("emails").child(Auth.auth().currentUser!.uid).setValue(self.emailField.text)
                    
                    
                    // Update the shares branch of the database
                    ref.child("shares").child(Auth.auth().currentUser!.uid).child("email").setValue(true)
                    ref.child("shares").child(Auth.auth().currentUser!.uid).child("phone_number").setValue(true)
                    ref.child("shares").child(Auth.auth().currentUser!.uid).child("linkedin").setValue(true)
                    ref.child("shares").child(Auth.auth().currentUser!.uid).child("github").setValue(true)
                    ref.child("shares").child(Auth.auth().currentUser!.uid).child("instagram").setValue(true)
                    
                    appEmail = self.emailField.text!
                    
                    
                    appUserName = self.firstNameField.text! + " " + self.lastNameField.text!
                    
                    
                    // Upload profile picture to the cloud
                    
                    appProfilePicture = self.profilePicture.image!
                    
                    let storageRef = Storage.storage().reference().child("profile_pictures").child(Auth.auth().currentUser!.uid)
                    
                    if let uploadData = self.profilePicture.image?.jpegData(compressionQuality: 1.0) {
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                return
                            }
                            
                             
                            self.performSegue(withIdentifier: "success", sender: self)
                        })
                    }
                }
            }
            
        }
       
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //image picker controller helps with picking an image from the library
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            selectedImageFromPicker = editedImage
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            selectedImageFromPicker = image
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profilePicture.image = selectedImage
        }
        
        //dismiss the page whenever user picks the image
        self.dismiss(animated: true, completion: nil)
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

