//
//  CollectionViewCell.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/22/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//
import UIKit

class RegisteredSocialProfile: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: SocialProfileCellDelegate?
    
    static let reuseIdentifier = "registeredSocialProfile"
    
    
    @IBAction func onAddToCartPressed(_ sender: Any) {
        addButtonTapAction?()
    }
    
    var addButtonTapAction : (()->())?

}

