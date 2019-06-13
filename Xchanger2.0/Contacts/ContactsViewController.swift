//
//  ContactsViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
}
