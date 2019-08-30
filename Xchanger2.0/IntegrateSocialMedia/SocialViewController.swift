//
//  SocialViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/29/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin
//import FBSDKLoginKit
import Alamofire
import Firebase
import FirebaseDatabase

var githubConnected = false
var instagramConnected = false



protocol SocialProfileCellDelegate:class {
    
        // Declare a delegate function holding a reference to `UICollectionViewCell` instance
        func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

class SocialViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var selectedIndustry = String()
    
    @IBOutlet weak var majorPicker: UIPickerView!
    
    @IBOutlet weak var socialProfiles: UICollectionView!
    
    var pictureArray = [UIImage] ()
    
//    var industries = ["Information Technology", "Marketing", "Human Resources", "Computer Software", "Financial Services", "Staffing and Recruiting", "Internet", "Management Consulting", "Telecommunications", "Retail"]
    
    var industries = ["Africana Studies", "Anthropology", "Arab Studies", "Art", "Biology", "Chemistry", "Chinese Studies", "Classics", "Communication Studies", "Computer Science", "East Asian Studies", "Economics", "English", "Environmental Studies", "French & Francophone Studies", "Gender & Sexuality Studies", "Genomics", "German Studies", "Hispanic Studies", "History", "Interdisplinary Studies", "Latin America Studies", "Mathematics", "Music", "Neuroscience", "Philosophy", "Physics", "Psychology", "Religion Studies", "Russian Studies", "Sociology", "Theatre", "Undecided"]
    
   
//    let facebookImage = #imageLiteral(resourceName: "Oval Copy-1")
    let linkedinImage = #imageLiteral(resourceName: "Oval Copy 5")
//    let googleImage = #imageLiteral(resourceName: "Oval Copy 3")
    let instagramImage = #imageLiteral(resourceName: "instagram_PNG11")
    let githubImage = #imageLiteral(resourceName: "Oval Copy 4")
//    let wechatImage = #imageLiteral(resourceName: "Oval Copy 6")

    var ref: DatabaseReference!
    

    @IBOutlet weak var studentOrg: UITextField!
    
    @IBOutlet weak var position: UITextField!
    
    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref1 = Database.database().reference().root.child("exchanges").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1")
        
        var coordinates = [Float]()
        coordinates.append(-80.84833526611328)
        coordinates.append(35.50434875488281)
        
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            ref1.setValue(coordinates)
        })
        
        let ref2 = Database.database().reference().root.child("exchanges").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2")
        
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            ref2.setValue(coordinates)
        })
        
        
        // Store what you could share with your contacts
     Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid).child("email").setValue(true)
    Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid).child("phone_number").setValue(true)
        Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid).child("linkedin").setValue(true)
        Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid).child("github").setValue(true)
        Database.database().reference().root.child("shares").child(Auth.auth().currentUser!.uid).child("instagram").setValue(true)
        
        // Sandbox User 1
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1").child("email").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1").child("phone_number").setValue(true)
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1").child("linkedin").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1").child("github").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1MGXWjBXY3h03c1FR042WFjYy2z1").child("instagram").setValue(true)
        
        // Sandbox User 2
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2").child("email").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2").child("phone_number").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2").child("linkedin").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2").child("github").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("F1Q4OP4rUsgxcONPNnHCOKndolk2").child("instagram").setValue(true)
        
        // Sandbox User 3
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1g6XdjW4YYaKlm1aExWPQmFMgn23").child("email").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1g6XdjW4YYaKlm1aExWPQmFMgn23").child("phone_number").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1g6XdjW4YYaKlm1aExWPQmFMgn23").child("linkedin").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1g6XdjW4YYaKlm1aExWPQmFMgn23").child("github").setValue(true)
        
    Database.database().reference().root.child("available").child(Auth.auth().currentUser!.uid).child("1g6XdjW4YYaKlm1aExWPQmFMgn23").child("instagram").setValue(true)
        
        
        firstLogin = true
        
        // Setup the picker
        majorPicker.delegate = self
        majorPicker.dataSource = self
        
        // Release the keyboard when tapping around
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
//        pictureArray.append(facebookImage)
        pictureArray.append(instagramImage)
//        pictureArray.append(googleImage)
        pictureArray.append(linkedinImage)
        pictureArray.append(githubImage)
//        pictureArray.append(wechatImage)
     self.navigationController?.setNavigationBarHidden(true, animated: false)
        
         ref = Database.database().reference()
        
    }
    
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
    
    func updateInstagram(){
        let IGURL = UserDefaults.standard.string(forKey: "IGUserURL") as! String
        self.ref.child("users/\(userID)/IGUserURL").setValue(IGURL)
    }
    
    func updateGithub(){
        let GitURL = UserDefaults.standard.string(forKey: "GHUserURL")
        appInstagramURL = GitURL!
        self.ref.child("users/\(userID)/GitUserURL").setValue(GitURL)
    }
    
    
    func updateIndustry(){
        let industry = selectedIndustry
        if (selectedIndustry != ""){
            self.ref.child("industry/\(userID)").setValue(industry)
        } else {
             self.ref.child("industry/\(userID)").setValue(self.industries[0])
        }
    
    }
    
    func updateStudentOrg(){
        self.ref.child("job_titles/\(userID)").setValue(self.studentOrg.text)
    }
    
    //  Perform seque and change the url depending on what social media it is coming from 
    @IBAction func startConnecting(_ sender: Any) {
        // Push user's three profiles to the database.
        
        if (instagramConnected){
        
            let IGURL = UserDefaults.standard.string(forKey: "IGUserURL")
            appInstagramURL = IGURL!
            self.updateInstagram()
        }
        
        self.updateIndustry()
        self.updateStudentOrg()
        
        if (githubConnected){
            let url = URL(string: "https://api.github.com/user")
            _ = URLRequest(url: url!)
            
            let headers: HTTPHeaders = [
                "Authorization": UserDefaults.standard.string(forKey: "GHAccessToken")!
            ]
            
            let accessToken = UserDefaults.standard.string(forKey: "GHAccessToken") as! String
            
            
            
            if let myUrl = url {
                var urlRequest = URLRequest(url: myUrl)
                urlRequest.httpMethod = HTTPMethod.get.rawValue
                
                urlRequest.addValue(" token \(accessToken)", forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
                Alamofire.request(urlRequest)
                    .responseJSON { response in
                        let JSONresponse = response.result.value as! NSDictionary
                        
                    let GHUserHTML = JSONresponse["html_url"]!
                        
                    appGithubURL = GHUserHTML as! String
                
                    UserDefaults.standard.set(GHUserHTML, forKey: "GHUserURL")
                    
                    self.updateGithub()
                    self.performSegue(withIdentifier: "registrationSuccess", sender: self)
                        
                }
            }
        } else {
            self.performSegue(withIdentifier: "registrationSuccess", sender: self)
        }
    }
    
    @IBAction func restore(_ sender: Any) {
        didSignUp = true
        finishedSignUp = true
    }
    

}

extension SocialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = socialProfiles.dequeueReusableCell(withReuseIdentifier: "socialProfile", for: indexPath) as? SocialProfile
    
        cell!.addButtonTapAction = {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if (indexPath.row == 0){
                self.performSegue(withIdentifier: "instagram", sender: self)
            } else if (indexPath.row == 1){
                self.performSegue(withIdentifier: "linkedin", sender: self)
            } else {
                self.performSegue(withIdentifier: "github", sender: self)
            }
        }
        
        cell?.button.setImage(pictureArray[indexPath.row], for: .normal)
        return cell!
    }
    
    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
}


