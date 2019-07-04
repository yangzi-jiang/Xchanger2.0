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
import MapKit
import MessageUI

class Pin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return title
    }
}

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // Shows where the user's met
    @IBOutlet weak var myMap: MKMapView!
    
    
    @IBOutlet weak var industryUILabel: UILabel!
    @IBOutlet weak var jobtitleUILabel: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    // Initialize the contact to be shown
    var userID  = String()
    
    // Information to pull from the database
    var myPhoneNumber = String()
    var myFullName = String()
//    var myImage = UIImage()
    var myEmail = String()
    
    var longitude = Float()
    var latitude = Float()
    
    
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
    
    
    
    
    var databaseReference = Database.database().reference()
    let storageReference = Storage.storage().reference()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        
        self.alertController.view.addSubview(spinnerIndicator)
        self.present(self.alertController, animated: false, completion: nil)
        
        
        // Process the image
    
        myImage.layer.borderWidth = 1.0
        myImage.layer.masksToBounds = false
        myImage.layer.borderColor = UIColor.white.cgColor
        myImage.layer.cornerRadius = myImage.frame.size.width / 2
        myImage.clipsToBounds = true
        
        
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
                    self.alertController.dismiss(animated:true)

                }
            }
        }
        
        
        var locationReference = databaseReference.child("exchanges").child(Auth.auth().currentUser!.uid)
        
        var locationToShow = CLLocation()
        
        locationReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let array = value![self.userID] as? NSArray
            
            self.longitude = (array?[0] as? Float)!
            self.latitude = (array?[1] as? Float)!
            
            locationToShow = CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
            
            self.centerMapOnLocation(location: locationToShow)
            
            let location = Pin(title: "You and your contact met here!", coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude)))
            
            // Create the annotation to show where your contact and you met
            
            self.myMap.addAnnotation(location)
        }
        
        var industryReference = databaseReference.child("industry")
        
            industryReference.observeSingleEvent(of: .value){
            (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let industry = value![self.userID] as? String
                
            self.industryUILabel.text = industry! + " |"
            
        }
        
        var jobTitleReference = databaseReference.child("job_titles")
        
        jobTitleReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let jobTitle = value![self.userID] as? String
            
            self.jobtitleUILabel.text = jobTitle!
        }
        
    
    }
    

    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        myMap.setRegion(coordinateRegion, animated: true)
    }
    
    
    @IBAction func emailClicked(_ sender: Any) {
        let checkEmail = Database.database().reference().child("available").child(Auth.auth().currentUser!.uid).child(self.userID)
        let emailRef = Database.database().reference().child("emails")
        
        checkEmail.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let email = dictionary!["email"] as? Bool
            
            if (email!){
                emailRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary1 = snapshot.value as? NSDictionary
                    let email = dictionary1![self.userID] as? String
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients([email!])
                        mail.setMessageBody("<p>It was nice to meet you through BOPP!</p>", isHTML: true)
                        
                        self.present(mail, animated: true)
                    } else {
                        // show failure alert
                    }
                })} else {
                //alert
            }
        }
    }
    
    @IBAction func githubClicked(_ sender: Any) {
        let checkGitHub = Database.database().reference().child("available").child(Auth.auth().currentUser!.uid).child(self.userID)
        let githubRef = Database.database().reference().child("users").child(self.userID)
        
        checkGitHub.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let github = dictionary!["github"] as? Bool
            
            if (github!){
                githubRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary1 = snapshot.value as? NSDictionary
                    let myGithub = dictionary1!["GitUserURL"] as? String
                    
                    if let url = URL(string: myGithub!) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            } else {
                // alert
            }
        }
        
    }
    @IBAction func phoneClicked(_ sender: Any) {
        let checkPhone = Database.database().reference().child("available").child(Auth.auth().currentUser!.uid).child(self.userID)
        let phoneNumberRef = Database.database().reference().child("phone_numbers")
        
        
        
        checkPhone.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            
            
            let phoneNumber = dictionary!["phone_number"] as? Bool

            
            if (phoneNumber!){
                phoneNumberRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary1 = snapshot.value as? NSDictionary
                    let phone = dictionary1![self.userID] as? String
                    guard let number = URL(string: "tel://" + phone!) else { return }
                    UIApplication.shared.open(number)
                })
            } else {
                // alert
            }
        }
        
    }
    
    @IBAction func instagramClicked(_ sender: Any) {
        let checkInstagram = Database.database().reference().child("available").child(Auth.auth().currentUser!.uid).child(self.userID)
        let instagramRef = Database.database().reference().child("users").child(self.userID)
        
        checkInstagram.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let instagram = dictionary!["instagram"] as? Bool
            
            if (instagram!){
                instagramRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary1 = snapshot.value as? NSDictionary
                    let myInsta = dictionary1!["IGUserURL"] as? String
                    
                    if let url = URL(string: myInsta!) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            } else {
                // alert
            }
        }
    }
    @IBAction func linkedinPressed(_ sender: Any) {
        let checkLinkedin = Database.database().reference().child("available").child(Auth.auth().currentUser!.uid).child(self.userID)
        let linkedinRef = Database.database().reference().child("users").child(self.userID)
        
        checkLinkedin.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as? NSDictionary
            let linkedin = dictionary!["linkedin"] as? Bool
            
            if (linkedin!){
                linkedinRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary1 = snapshot.value as? NSDictionary
                    let myLinkedin = dictionary1!["LIUserURL"] as? String
                    
                    if let url = URL(string: myLinkedin!) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            } else {
                // alert
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
