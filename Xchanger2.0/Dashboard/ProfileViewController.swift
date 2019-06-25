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
import CoreLocation
import MapKit

var firstLogin = false


var userLongitude = 0.0
var userLatitude = 0.0





class ProfileViewController: UIViewController {
    
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
    
    
    let locationManager = CLLocationManager()
    
     let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set notifications for changing pages
        
        NotificationCenter.default.addObserver(self, selector: #selector(showSettings), name: NSNotification.Name("ShowSettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showContacts), name: NSNotification.Name("ShowContacts"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)
        
        
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
        
        // Update the profile page
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
            
        } else {
            firstLogin = false
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(dismissAlert), name: NSNotification.Name("ReleaseLoad"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (appProfilePicture.size.height == 0.0 && appProfilePicture.size.width == 0.0){
            let reference = Storage.storage().reference().child("profile_pictures").child(appUserID)
            
            reference.getData(maxSize: (1024 * 1024 * 1024)) { (data, error) in
                if let _error = error {
                    print("works")
                } else {
                    if let _data  = data {
                        let myImage:UIImage! = UIImage(data: _data)
                        
                            self.alertController.dismiss(animated: true)
                        
                        self.myProfilePicture.image = myImage
                    }
                }
            }
        } else {
            self.alertController.dismiss(animated:true)
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
}
