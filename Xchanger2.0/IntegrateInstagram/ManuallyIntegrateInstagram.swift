//
//  ManuallyIntegrateInstagram.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 9/4/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth


class ManuallyIntegrateInstagram: UIViewController {

    @IBOutlet weak var instagramUser: UITextField!
    var user = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func updateYourLinkedin(_ sender: Any) {
        
        
        var reference = Database.database().reference()
        reference.child("users").child(user!).child("IGUserURL").setValue("https://instagram.com/" + instagramUser.text!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }

}


