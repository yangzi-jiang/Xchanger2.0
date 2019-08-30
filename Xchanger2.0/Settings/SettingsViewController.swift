//
//  SettingsViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    // Fields
    
    @IBOutlet weak var myEmail: UITextField!
    @IBOutlet weak var myPhoneNumber: UITextField!
    @IBOutlet weak var myJobTitle: UITextField!
    
    @IBOutlet weak var industryPickerView: UIPickerView!
    
    var selectedIndustry = String()
    
//    var industries = ["Information Technology", "Marketing", "Human Resources", "Computer Software", "Financial Services", "Staffing and Recruiting", "Internet", "Management Consulting", "Telecommunications", "Retail"]
    
    var industries = ["Africana Studies", "Anthropology", "Arab Studies", "Art", "Biology", "Chemistry", "Chinese Studies", "Classics", "Communication Studies", "Computer Science", "East Asian Studies", "Economics", "English", "Environmental Studies", "French & Francophone Studies", "Gender & Sexuality Studies", "Genomics", "German Studies", "Hispanic Studies", "History", "Interdisplinary Studies", "Latin America Studies", "Mathematics", "Music", "Neuroscience", "Philosophy", "Physics", "Psychology", "Religion Studies", "Russian Studies", "Sociology", "Theatre", "Undecided"]
    
    var reference = Database.database().reference()
    var myUser = Auth.auth().currentUser?.uid as? NSString
    
    // Update Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return industries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return industries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndustry = industries[row]
        print(industries[row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the picker
        industryPickerView.delegate = self
        industryPickerView.dataSource = self
        
        let emailAddressReference = reference.child("emails")
        
        emailAddressReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.myEmail.text = value![self.myUser] as! String
        }
        
        let phoneNumberReference = reference.child("phone_numbers")
        
        phoneNumberReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.myPhoneNumber.text = value![self.myUser] as! String
        }
        
        let jobTitleReference = reference.child("job_titles")
        
        jobTitleReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.myJobTitle.text = value![self.myUser] as! String
        }
        
        let industryReference = reference.child("industry")
        
        industryReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let industry = value![self.myUser] as! String
            
            var myIndex = 0
            
            for i in 0 ..< self.industries.count {
                if (self.industries[i] == industry){
                    myIndex = i
                }
            }
            
            self.industryPickerView.selectRow(myIndex, inComponent: 0, animated: true)

        }
        
    }
    
    



    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func updateDatabase(_ sender: Any) {
        // ref.child("shares").child(Auth.auth().currentUser!.uid).child("instagram").setValue(true)
        
        // Update email address
        var emailAddressReference = reference.child("emails").child(self.myUser as! String)
        emailAddressReference.setValue(myEmail.text)
        
        // Update phone number
        var phoneNumberReference = reference.child("phone_numbers").child(self.myUser as! String)
        phoneNumberReference.setValue(myPhoneNumber.text)
        
        // Update job title
        
        var jobTitleReference = reference.child("job_titles").child(self.myUser as! String)
        jobTitleReference.setValue(myJobTitle.text)
        
        // Update industry
        let industry = selectedIndustry
        if (selectedIndustry != ""){
             reference.child("industry/\(self.myUser as! String)").setValue(industry)
        }
       
    
    }
    
    
    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
}
