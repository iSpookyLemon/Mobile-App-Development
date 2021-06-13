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
    
    var image: UIImage!
    
    var data = [DocumentSnapshot]()
    
    var searchType: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        setSearchBarType(searchBar.selectedScopeButtonIndex)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Search bar config
    
    func setSearchBarType(_ index: Int) {
        if index == 0 {
            searchType = "fullnamelower"
        } else if index == 1 {
            searchType = "fullnamelower"
        } else {
            searchType = "freelanceServiceLower"
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        setSearchBarType(selectedScope)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let db = Firestore.firestore()
        let searchString = searchBar.text!.lowercased()
        
        self.data.removeAll()
        
        if searchString != "" {
            db.collection("users")
                .whereField(searchType, isLessThanOrEqualTo: searchString + "\u{f8ff}")
                .whereField(searchType, isGreaterThanOrEqualTo: searchString)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.data = querySnapshot!.documents
                        self.tableView.reloadData()
                    }
            }
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        var cellText = ""
        
        let document = data[indexPath.row]
        
        if searchType == "fullnamelower" {
            let firstName = document.get("firstname") as? String ?? "Error"
            let lastName = document.get("lastname") as? String ?? "Error"
            cellText = firstName + " " + lastName
        } else if searchType == "freelanceServiceLower" {
            let firstName = document.get("firstname") as? String ?? "Error"
            let lastName = document.get("lastname") as? String ?? "Error"
            let service = document.get("freelanceService") as? String ?? "Error"
            cellText = firstName + " " + lastName + " (" + service + ")"
        }
        
        cell.textLabel?.text = cellText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = data[indexPath.row]
        
        let firstName = selectedUser.get("firstname") as? String ?? "Error"
        let lastName = selectedUser.get("lastname") as? String ?? "Error"
        let description = selectedUser.get("description") as? String ?? "Hello, my name is " + firstName + " " + lastName
        let contact = selectedUser.get("phoneNumber") as? String ?? "No phone number available"
        
        let uid = selectedUser.documentID
        
        if let viewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.userViewController) as? UserViewController {
            
            viewController.person.name = firstName + " " + lastName
            viewController.person.description = description
            viewController.person.contact = contact
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
                print("1")
            }
            completion()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
