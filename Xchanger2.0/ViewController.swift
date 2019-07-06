//
//  ViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 5/26/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

var didSignUp = false
var finishedSignUp = false

class ViewController: UIViewController {

    @IBOutlet weak var InitialBackground: UIImageView!
    @IBOutlet weak var InitialQuestion: UILabel!
    @IBOutlet weak var SocialButterfly: UIButton!
    @IBOutlet weak var EventPlanner: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
//        SocialButterfly.titleLabel?.numberOfLines = 0;
        SocialButterfly.titleLabel?.minimumScaleFactor = 0.5
        SocialButterfly.titleLabel?.adjustsFontSizeToFitWidth = true
//        EventPlanner.titleLabel?.numberOfLines = 0;
        EventPlanner.titleLabel?.minimumScaleFactor = 0.5
        EventPlanner.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
}

