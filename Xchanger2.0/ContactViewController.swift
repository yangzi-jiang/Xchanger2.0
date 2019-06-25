//
//  ContactViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/24/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ContactViewController: UIViewController {
    
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    // Initialize the contact to be shown
    var userID  = String()
    
    // Information to pull from the database
    var myPhoneNumber = String()
    var myFullName = String()
//    var myImage = UIImage()
    var myEmail = String()
    
    
    var databaseReference = Database.database().reference()
    let storageReference = Storage.storage().reference()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
        // Pull the person's name
        
        let usernameReference = databaseReference.child("full_names")
        
        usernameReference.observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
//            self.myFullName = (value?[self.userID] as? String)!
            self.myName.text = (value?[self.userID] as? String)!
        }
        
        // Pull the person's email
        
        let emailReference = databaseReference.child("emails")
        
        emailReference.observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.myEmail = (value?[self.userID] as? String)!
            print(self.myEmail)
        }
        
        // Pull the person's phone number
        
        let phonenumberReference = databaseReference.child("phone_numbers")
        
        phonenumberReference.observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.myPhoneNumber = (value?[self.userID] as? String)!
        }
        
        var imageReference = storageReference.child("profile_pictures").child(self.userID)
        
        imageReference.getData(maxSize: (1024 * 1024 * 1024)) { (data, error) in
            if let _error = error {
                print("doesn't work")
            } else {
                if let _data  = data {
                    let image:UIImage! = UIImage(data: _data)
                    self.myImage.image = image
                }
            }
        }
        
        

        
        
        
        
    }
}
