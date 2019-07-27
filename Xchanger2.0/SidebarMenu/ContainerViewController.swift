//
//  ContainerViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var sidebarOpen = false
    @IBOutlet weak var layoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleBar), name: NSNotification.Name("ToggleBar"), object: nil)
        
    
    }
    
    @objc func toggleBar(){
        if (sidebarOpen){
            sidebarOpen = false
            layoutConstraint.constant
                = -165
        } else {
            layoutConstraint.constant = 0
            sidebarOpen = true
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

    // Lock Portrait Orientation
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            print("Swipe Left")
            
        }
        
        if (sender.direction == .right) {
            print("Swipe Right")
        }
    }
}
