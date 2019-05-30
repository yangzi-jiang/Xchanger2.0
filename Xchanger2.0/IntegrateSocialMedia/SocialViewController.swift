//
//  SocialViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/29/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

protocol SocialProfileCellDelegate:class {
    
        // Declare a delegate function holding a reference to `UICollectionViewCell` instance
        func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton)
}
class SocialViewController: UIViewController {

    @IBOutlet weak var socialProfiles: UICollectionView!
    
    var pictureArray = [UIImage] ()
    
    let facebookImage = #imageLiteral(resourceName: "Oval Copy-1")
    let linkedinImage = #imageLiteral(resourceName: "Oval Copy 5")
    let googleImage = #imageLiteral(resourceName: "Oval Copy 3")
    let instagramImage = #imageLiteral(resourceName: "instagram_PNG11")
    let githubImage = #imageLiteral(resourceName: "Oval Copy 4")
    let wechatImage = #imageLiteral(resourceName: "Oval Copy 6")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pictureArray.append(facebookImage)
        pictureArray.append(instagramImage)
        pictureArray.append(googleImage)
        pictureArray.append(linkedinImage)
        pictureArray.append(githubImage)
        pictureArray.append(wechatImage)
        
    }
    
    //  Perform seque and change the url depending on what social media it is coming from 

}

extension SocialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = socialProfiles.dequeueReusableCell(withReuseIdentifier: "socialProfile", for: indexPath) as? SocialProfile
        
        cell!.addButtonTapAction = {
            // Perform action here
        }
        cell?.button.setImage(pictureArray[indexPath.row], for: .normal)
        return cell!
    }
    
  
}


