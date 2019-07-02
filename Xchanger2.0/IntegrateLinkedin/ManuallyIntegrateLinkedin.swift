//
//  ManuallyIntegrateLinkedin.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 7/2/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ManuallyIntegrateLinkedin: ViewController {

    @IBOutlet weak var myLinkedinPage: UITextField!
    
    var user = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func updateYourLinkedin(_ sender: Any) {
        
        
        var reference = Database.database().reference()
    reference.child("linkedin_profiles").child(user!).setValue(myLinkedinPage.text)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
