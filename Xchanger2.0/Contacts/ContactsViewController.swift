//
//  ContactsViewController.swift
//  Xchanger2.0
//
//  Created by Altan Tutar on 6/12/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

//    @IBOutlet weak var textView: UITextView!
    
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        textView.text = text
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
}
