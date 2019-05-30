//
//  SocialProfile.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/29/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

class SocialProfile: UICollectionViewCell {
   
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: SocialProfileCellDelegate?
    
    static let reuseIdentifier = "socialProfile"

    
    @IBAction func onAddToCartPressed(_ sender: Any) {
        addButtonTapAction?()
    }

    var addButtonTapAction : (()->())?
    
    
}
