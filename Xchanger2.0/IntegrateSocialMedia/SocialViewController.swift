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



protocol SocialProfileCellDelegate:class {
    
        // Declare a delegate function holding a reference to `UICollectionViewCell` instance
        func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}

class SocialViewController: UIViewController {

    @IBOutlet weak var socialProfiles: UICollectionView!
    
    var pictureArray = [UIImage] ()
    
//    let facebookImage = #imageLiteral(resourceName: "Oval Copy-1")
    let linkedinImage = #imageLiteral(resourceName: "Oval Copy 5")
//    let googleImage = #imageLiteral(resourceName: "Oval Copy 3")
    let instagramImage = #imageLiteral(resourceName: "instagram_PNG11")
    let githubImage = #imageLiteral(resourceName: "Oval Copy 4")
//    let wechatImage = #imageLiteral(resourceName: "Oval Copy 6")

    var ref: DatabaseReference!
    
    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func updateSwift(){
        
        let IGURL = UserDefaults.standard.string(forKey: "IGUserURL") as! String
        let GHURL = UserDefaults.standard.string(forKey: "GHUserURL") as! String
        
        // Update
        
        print("called")
        self.ref.child("users/\(userID)/IGUserURL").setValue(IGURL)
        self.ref.child("users/\(userID)/GHUserURL").setValue(GHURL)
    
    }
    
    //  Perform seque and change the url depending on what social media it is coming from 
    @IBAction func startConnecting(_ sender: Any) {
        // Push user's three profiles to the database.
        
        var IGURL = UserDefaults.standard.string(forKey: "IGUserURL")
        
        appInstagramURL = IGURL!
        
        // GHAccessToken
        let url = URL(string: "https://api.github.com/user")
        var request = URLRequest(url: url!)
        
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
                
                self.updateSwift()
                self.performSegue(withIdentifier: "registrationSuccess", sender: self)
            }
        }
    }
    
    
    @IBAction func startConnect(_ sender: Any) {
        firstLogin = true
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
    
  
}


