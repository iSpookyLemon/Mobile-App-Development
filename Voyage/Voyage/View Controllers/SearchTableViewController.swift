//
//  SearchTableViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/25/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // create image variable to store the profile image
    var image: UIImage!
    
    // create array to store data to be displayed on table view
    var data = [DocumentSnapshot]()
    
    // String that identifies search type (i.e. user, location, or service)
    var searchType: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the serach bar delegate
        searchBar.delegate = self
        setSearchBarType(searchBar.selectedScopeButtonIndex)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Search bar config
    
    func setSearchBarType(_ index: Int) {
        // Determine the search type
        if index == 0 {
            searchType = "fullnamelower"
        } else if index == 1 {
            searchType = "locationlower"
        } else {
            searchType = "freelanceServiceLower"
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // set the search bar type if the scope bar is changed
        setSearchBarType(selectedScope)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // create a firestore object
        let db = Firestore.firestore()
        
        // create the search string
        let searchString = searchBar.text!.lowercased()
        
        // Clear all data from the table view
        self.data.removeAll()
        
        // Check if searchString is empty
        if searchString == "" {
            // reload the table view
            self.tableView.reloadData()
        } else {
            // Perform a query to find users/locations/services that being with the searchString
            db.collection("users")
                .whereField(searchType, isLessThanOrEqualTo: searchString + "\u{f8ff}")
                .whereField(searchType, isGreaterThanOrEqualTo: searchString)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        // There was an error
                        print("Error getting documents: \(err)")
                    } else {
                        // Fill the data array
                        self.data = querySnapshot!.documents
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Show cancel button if the search bar text is edited
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // Conceal cancel button when user stops editing earch bar
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Cancels editing when cancel button is clicked
        searchBar.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows = number of data values

        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create tableviewcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        // create cell text
        var cellText = ""
        
        // get the document for the specific row
        let document = data[indexPath.row]
        
        if searchType == "fullnamelower" {
            // Just display full name
            let firstName = document.get("firstname") as? String ?? "Error"
            let lastName = document.get("lastname") as? String ?? "Error"
            cellText = firstName + " " + lastName
        } else if searchType == "locationlower" {
            // Display name and location
            let firstName = document.get("firstname") as? String ?? "Error"
            let lastName = document.get("lastname") as? String ?? "Error"
            let location = document.get("location") as? String ?? "Error"
            cellText = firstName + " " + lastName + " (" + location + ")"
        } else if searchType == "freelanceServiceLower" {
            // Display name and service
            let firstName = document.get("firstname") as? String ?? "Error"
            let lastName = document.get("lastname") as? String ?? "Error"
            let service = document.get("freelanceService") as? String ?? "Error"
            cellText = firstName + " " + lastName + " (" + service + ")"
        }
        
        // set the text of the cell to cellText
        cell.textLabel?.text = cellText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get info for the selected user
        let selectedUser = data[indexPath.row]
        
        // Get details about selected user
        let firstName = selectedUser.get("firstname") as? String ?? "Error"
        let lastName = selectedUser.get("lastname") as? String ?? "Error"
        let description = selectedUser.get("description") as? String ?? "Hello, my name is " + firstName + " " + lastName
        let contact = selectedUser.get("phoneNumber") as? String ?? "No phone number available"
        let location = selectedUser.get("location") as? String ?? "No location available"
        let isSeller = selectedUser.get("isSeller") as? Bool ?? false
        let service = selectedUser.get("freelanceService") as? String ?? "No service"
        let price = selectedUser.get("dollarsPerHour") as? String ?? "No price"
        
        let uid = selectedUser.documentID
        
        // Create a view controller to display
        if let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.userViewController) as? UserViewController {
            
            // Assign values to the Person subclass in the view controller
            viewController.person.name = firstName + " " + lastName
            viewController.person.description = description
            viewController.person.contact = contact
            viewController.person.location = location
            viewController.person.isSeller = isSeller
            viewController.person.service = service
            viewController.person.price = price
            // Download the user's profile image
            downloadImage(uid) {
                viewController.person.profileImage = self.image
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func downloadImage(_ uid: String, completion: @escaping () -> Void){
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child(uid + "/profile.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                self.image = UIImage(systemName: "person.circle")
            } else {
                // Data is returned
                self.image = UIImage(data: data!)
            }
            // Notify that the function is complete
            completion()
        }
    }

}
