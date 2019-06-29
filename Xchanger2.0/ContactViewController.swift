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

class ContactViewController: UIViewController {
    
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
    
    
    
    var databaseReference = Database.database().reference()
    let storageReference = Storage.storage().reference()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
