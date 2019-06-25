//
//  ContactsTableViewController.swift
//  Xchanger2.0
//
//  Created by Yangzi Jiang on 6/21/19.
//  Copyright © 2019 Altan Tutar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ContactsTableViewController: UITableViewController {

    // Hold the names of contacts in an array list
    var myContacts: [String: AnyObject] = [:]
    var finalNames = [String: String]()
    var currentItem = ""
    
    
    // Intialize the database reference
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the database reference whenever the view is loaded
        ref = Database.database().reference()
        let contactsReference = ref.child("exchanges").child(Auth.auth().currentUser!.uid)
        let nameReference = ref.child("full_names")

        // Download the user's contacts
        var refHandle = contactsReference.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.myContacts = postDict
            print(self.myContacts.keys.count)
            if (self.myContacts.keys.count != 0){
                // Call the completion handler
                print("Here")
                self.getUserNames(reference: nameReference)
            }
        })
        
//        let nameReference = ref.child("full_names")
//        for userID in self.myContacts.keys {
//            refHandle = nameReference.child(userID).observe(DataEventType.value, with: { (snapshot) in
//                print(snapshot.value)
//            })
//        }
//
    }
    
    func getUserNames(reference: DatabaseReference){
        print("From user names!")
        let nameReference = ref.child("full_names")
        
       
            var refHandle = nameReference.observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                for userID in self.myContacts.keys {
                self.finalNames[postDict[userID] as! String] = userID
                }
                
                self.tableView.reloadData()
            })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalNames.keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let stringArray = Array(self.finalNames.keys.map { String($0) })

        cell.textLabel?.text = stringArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stringArray = Array(self.finalNames.keys.map { String($0) })

        currentItem = self.finalNames[stringArray[indexPath.row]]!
        
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ContactViewController {
            
            destinationViewController.userID = currentItem
        }
    }
}
