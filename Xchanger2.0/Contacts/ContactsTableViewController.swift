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

class ContactsViewController:  UIViewController, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    // Hold the names of contacts in an array list
    var myContacts: [String: AnyObject] = [:]
    var finalNames = [String: String]()
    var currentItem = ""
    var filteredData: [String]!
    
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
//            print(self.myContacts.keys.count)
            if (self.myContacts.keys.count != 0){
                // Call the completion handler
                print("Here")
                print("From user names!")
                var refHandle2 = nameReference.observe(DataEventType.value, with: { (snapshot) in
                    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                    self.myContacts = postDict
//                    for userID in self.myContacts.keys {
//                        self.finalNames[postDict[userID] as! String] = userID
//                    }
                    
                    self.tableView.reloadData()
                })
            }
        })
//        tableView.dataSource = self
//        searchBar.delegate = self
        filteredData = Array(myContacts.keys)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? Array(myContacts.keys) : Array(myContacts.keys).filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        let stringArray = Array(self.finalNames.keys.map { String($0) })
//
//        cell.textLabel?.text = stringArray[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let stringArray = Array(self.finalNames.keys.map { String($0) })
//
//        currentItem = self.finalNames[stringArray[indexPath.row]]!
//
//        performSegue(withIdentifier: "showDetail", sender: nil)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationViewController = segue.destination as? ContactViewController {
//
//            destinationViewController.userID = currentItem
//        }
//    }
//
//    // Lock Portrait Orientation
//    override func viewWillAppear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
//
//    }
}
