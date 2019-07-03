//
//  ProfileViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/8/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import CoreLocation
import MapKit

var firstLogin = false
var signUp = false


var userLongitude = 0.0
var userLatitude = 0.0


class ProfileViewController: UIViewController {
    
    // Ticks for representing what to share
    @IBOutlet weak var phoneTick: UIImageView!
    @IBOutlet weak var emailTick: UIImageView!
    @IBOutlet weak var linkedinTick: UIImageView!
    @IBOutlet weak var githubTick: UIImageView!
    @IBOutlet weak var instagramTick: UIImageView!
    
    
    @IBOutlet weak var myProfilePicture: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myQRCode: UIImageView!
    
    // Array of pictures for the toggle buttons
    var pictureArray = [UIImage] ()
    
    //    let facebookImage = #imageLiteral(resourceName: "Oval Copy-1")
    let phoneImage = #imageLiteral(resourceName: "icons8-shake-phone-100")
    let emailImage = #imageLiteral(resourceName: "icons8-new-post-100")
    
    let linkedinImage = #imageLiteral(resourceName: "Oval Copy 5")
    //    let googleImage = #imageLiteral(resourceName: "Oval Copy 3")
    let instagramImage = #imageLiteral(resourceName: "instagram_PNG11")
    let githubImage = #imageLiteral(resourceName: "Oval Copy 4")
    
    //    let wechatImage = #imageLiteral(resourceName: "Oval Copy 6")
    
    @IBOutlet weak var industryUILabel: UILabel!
    @IBOutlet weak var jobtitleUILabel: UILabel!
    
    // Declare variables for contact exchange
    var email = true
    var phoneNumber = true
    var linkedin = true
    var github = true
    var instagram = true

    let locationManager = CLLocationManager()
    
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // See what is available to share for the current person
        
//        var available0 = Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid)
//        
//        var available1 = Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid)
//        
//        available0.observeSingleEvent(of: .value) { (snapshot) in
//            let dictionary = snapshot.value as? NSDictionary
//            available1.setValue(dictionary)
//            print(dictionary)
//        }
        
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettings), name: NSNotification.Name("ShowSettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showContacts), name: NSNotification.Name("ShowContacts"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name("Logout"), object: nil)
        
        
        // Create a QR Code with User ID
        let data = appUserID.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        let img = UIImage(ciImage: transformImage!)
        
        appQRCode = img
        
        // Process the image
        myProfilePicture.layer.borderWidth = 1.0
        myProfilePicture.layer.masksToBounds = false
        myProfilePicture.layer.borderColor = UIColor.white.cgColor
        myProfilePicture.layer.cornerRadius = myProfilePicture.frame.size.width / 2
        myProfilePicture.clipsToBounds = true
        
        
        
        var reference = Database.database().reference()
        
        reference.child("shares").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
        
            // Update variables
            self.email = ((value?["email"]) != nil)
            self.github = ((value?["github"]) != nil)
            self.instagram = ((value?["instagram"]) != nil)
            self.phoneNumber = ((value?["phone_number"]) != nil)
            self.github = ((value?["github"]) != nil)
            
            
            // Update ticks
            if (self.email == true){
                self.emailTick.alpha = 1.0
            } else {
                self.emailTick.alpha = 0.0
            }
            
            if (self.github == true){
                self.githubTick.alpha = 1.0
            } else {
                self.githubTick.alpha = 0.0
            }
            
            
            if (self.linkedin == true){
                self.linkedinTick.alpha = 1.0
            } else {
                self.linkedinTick.alpha = 0.0
            }
            
            if (self.instagram == true){
                self.instagramTick.alpha = 1.0
            } else {
                self.instagramTick.alpha = 0.0
            }
            
            if (self.phoneNumber == true){
                self.phoneTick.alpha = 1.0
            } else {
                self.phoneTick.alpha = 0.0
            }
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        }
        
        // Set notifications for changing pages
        
        myProfilePicture.image = appProfilePicture
        myName.text = appUserName
        myQRCode.image = appQRCode
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
     
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
    
        
        if (!firstLogin){
            self.alertController.view.addSubview(spinnerIndicator)
            self.present(self.alertController, animated: false, completion: nil)
            firstLogin = true
        } else {
            // Update the profile page
            myProfilePicture.image = appProfilePicture
            myName.text = appUserName
            myQRCode.image = appQRCode
        }
        
        
        
      
        
//        if (signUp == true){
//            signUp = false
//        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(dismissAlert), name: NSNotification.Name("ReleaseLoad"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (appProfilePicture.size.height == 0.0 && appProfilePicture.size.width == 0.0){
            let reference = Storage.storage().reference().child("profile_pictures").child(Auth.auth().currentUser!.uid)
            
           
            reference.getData(maxSize: (1024 * 1024 * 1024)) { (data, error) in
                if let _error = error {
                    print("works")
                } else {
                    if let _data  = data {
                        let myImage:UIImage! = UIImage(data: _data)
                        appProfilePicture = myImage
                        self.alertController.dismiss(animated: true)
                        self.myProfilePicture.image = myImage
                    }
                }
            }
        } else {
            self.alertController.dismiss(animated:true)
        }
        
        // Database References
        
        let databaseReference = Database.database().reference()
        
        let jobtitlesReference = databaseReference.child("job_titles")
        let industryReference = databaseReference.child("industry")
        
       
        jobtitlesReference.observeSingleEvent(of: .value) { (snapshot) in
             let value = snapshot.value as? NSDictionary
            self.jobtitleUILabel.text = value?[Auth.auth().currentUser?.uid] as! String
        }
        
        industryReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.industryUILabel.text = value?[Auth.auth().currentUser?.uid] as! String + " | "
        
        }
        
        let namesReference = databaseReference.child("full_names")
        
        namesReference.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.myName.text = value?[Auth.auth().currentUser?.uid] as! String
            
        }
        
        
            
        
        checkLocationServices()
    }
    
    @objc func dismissAlert(){
        self.alertController.dismiss(animated:true)
    }

    @IBAction func sidebarTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleBar"), object: nil)
    }
    
    @objc func showProfile(){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleBar"), object: nil)
    }
    
    @objc func showContacts(){
        self.performSegue(withIdentifier: "contacts", sender: self)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleBar"), object: nil)
    }
    
    @objc func showSettings(){
        self.performSegue(withIdentifier: "settings", sender: self)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleBar"), object: nil)
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            locationManager.requestLocation()
        } else {
            // Show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
             break
//        @unknown default:
//            <#code#>
        }
    }
    
    func changeSharesChild(changed: String, boolValue: Bool){
    Database.database().reference().child("shares").child(Auth.auth().currentUser!.uid).child(changed).setValue(boolValue)
    }
    
    @IBAction func phonePressed(_ sender: Any) {
        // Turns the tick off if phone is not selected, and turns it on if phone is selected
        if (phoneNumber == true){
            phoneTick.alpha = 0.0
            phoneNumber = false
            changeSharesChild(changed: "phone_number", boolValue: false)
        } else {
            phoneTick.alpha = 1.0
            phoneNumber = true
            changeSharesChild(changed: "phone_number", boolValue: true)
        }
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        // Turns the tick off if phone is not selected, and turns it on if phone is selected
        if (email == true){
            emailTick.alpha = 0.0
            email = false
            changeSharesChild(changed: "email", boolValue: false)
        } else {
            emailTick.alpha = 1.0
            email = true
            changeSharesChild(changed: "email", boolValue: true)
        }
    }
    
    @IBAction func linkedinPressed(_ sender: Any) {
        // Turns the tick off if linkedin is not selected, and turns it on if linkedin is selected
        if (linkedin == true){
            linkedinTick.alpha = 0.0
            linkedin = false
            changeSharesChild(changed: "linkedin", boolValue: false)
        } else {
            linkedinTick.alpha = 1.0
            linkedin = true
            changeSharesChild(changed: "linkedin", boolValue: true)
        }
    }
    
    @IBAction func githubPressed(_ sender: Any) {
        // Turns the tick off if github is not selected, and turns it on if github is selected
        if (github == true){
            githubTick.alpha = 0.0
            github = false
            changeSharesChild(changed: "github", boolValue: false)
        } else {
            githubTick.alpha = 1.0
            github = true
            changeSharesChild(changed: "github", boolValue: true)
        }
    }
    
    
    @IBAction func instagramPressed(_ sender: Any) {
        // Turns the tick off if instagram is not selected, and turns it on if instagram is pressed
        if (instagram == true){
            instagramTick.alpha = 0.0
            instagram = false
            changeSharesChild(changed: "instagram", boolValue: false)
        } else {
            instagramTick.alpha = 1.0
            instagram = true
            changeSharesChild(changed: "instagram", boolValue: true)
        }
    }
}

extension ProfileViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        print(userLatitude)
        print(userLongitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail")
    }
    
    @objc func logout(){
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        didSignUp = false
        self.performSegue(withIdentifier: "unwind", sender: self)

        
//
//        self.performSegue(withIdentifier: "unwindSegueToVC1", sender: self)

        
    }
}
