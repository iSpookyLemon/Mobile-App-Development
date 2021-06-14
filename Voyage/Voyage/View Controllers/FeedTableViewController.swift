//
//  FeedTableViewController.swift
//  Voyage
//
//  Created by Kevin K. Li on 5/26/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FeedTableViewController: UITableViewController {
    
    // Create the Person subclass to store user information
    class Person {
        var firstName: String!
        var lastName: String!
        var service: String!
        var uid: String!
        var price: String!
        var contact: String!
        var profileImage: UIImage!
        var location: String!
    }
    
    // Create data that will populate table view
    var data = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get user information
        getFeed() {
            // Reload the table view with the retrieved data
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getFeed(completion: @escaping () -> Void) {
        // Create a firestore object
        let db = Firestore.firestore()
        
        // Query for users who are sellers
        db.collection("users").whereField("isSeller", isEqualTo : true).limit(to: 6).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                // There was an error
                print("Error getting documents: \(err)")
                completion()
            } else {
                // Dispatch Group makes the view wait for all of the data to be retrieved until loading the view
                let group = DispatchGroup()
                
                for document in querySnapshot!.documents {
                    // Create a Person object
                    let person = Person()
                    
                    let uid = document.documentID
                    
                    // Set the attributes of person
                    person.firstName = document.get("firstname") as? String ?? "Error"
                    person.lastName = document.get("lastname") as? String ?? "Error"
                    person.service = document.get("freelanceService") as? String ?? "Error"
                    person.price = document.get("dollarsPerHour") as? String ?? "Error"
                    person.contact = document.get("phoneNumber") as? String ?? "Error"
                    person.location = document.get("location") as? String ?? "Error"
                    
                    group.enter()
                    
                    // Doenload the image
                    self.downloadImage(uid: uid, person: person) {
                        self.data.append(person)
                        group.leave()
                    }
                }
                // When all tasks are complete the function is complete
                group.notify(queue: .main) {
                    completion()
                }
            }
        }
    }
    
    func downloadImage(uid: String, person: Person, completion: @escaping () -> Void) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child(uid + "/profile.jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error != nil {
                // No image was found or and error occured, so the profile image is default
                person.profileImage = UIImage(systemName: "person.circle")
            } else {
                // Data is returned
                person.profileImage = UIImage(data: data!)
            }
            completion()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows = count of data
        return data.count
    }

    // Create the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of a user table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        
        // Fetch data for row
        let person = data[indexPath.row]
        
        // Set ui elements in cells to retrieved values
        cell.profileImage.image = person.profileImage
        cell.name.text = person.firstName + " " + person.lastName
        cell.service.text = person.service
        cell.price.text = "$" + person.price
        // Check to see of there is contact information
        if person.contact != "No phone number available" {
            cell.contact.text = Utilities.formatPhoneNumber(person.contact)
        } else {
            cell.contact.text = person.contact
        }
        cell.location.text = person.location
            
        return cell
    }

}
