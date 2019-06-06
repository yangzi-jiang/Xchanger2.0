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
        
    }
    
    //  Perform seque and change the url depending on what social media it is coming from 
    @IBAction func startConnecting(_ sender: Any) {
        // Push user's three profiles to the database.
        print("here")
        var IGURL = UserDefaults.standard.string(forKey: "IGUserURL")
        
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
                    
                    print(JSONresponse["html_url"]!)
            }
        }
    

//        request.httpMethod = "GET"

//        request.addValue(" token \(accessToken!))", forHTTPHeaderField: "Authorization")
//        request.addValue(" application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//        request.addValue(" Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 YaBrowser/16.3.0.7146 Yowser/2.5 Safari/537.36", forHTTPHeaderField: "User-Agent")
//
//        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json)
//        }
//
//        task.resume()
        
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


