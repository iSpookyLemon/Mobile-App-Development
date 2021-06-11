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
    
    class Person {
        var firstName: String!
        var lastName: String!
        var service: String!
        var uid: String!
        var price: String!
        var contact: String!
        var profileImage: UIImage!
    }
    
    var data = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFeed() {
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getFeed(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("isSeller", isEqualTo : true).limit(to: 6).getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completion()
            } else {
                let group = DispatchGroup()
                
                for document in querySnapshot!.documents {
                    
                    let person = Person()
                    
                    let uid = document.documentID
                    
                    person.firstName = document.get("firstname") as? String ?? "Error"
                    person.lastName = document.get("lastname") as? String ?? "Error"
                    person.service = document.get("freelanceService") as? String ?? "Error"
                    person.price = document.get("dollarsPerHour") as? String ?? "Error"
                    person.contact = document.get("phoneNumber") as? String ?? "Error"
                    
                    group.enter()
                    self.downloadImage(uid: uid, person: person) {
                        self.data.append(person)
                        group.leave()
                    }
                }
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
        imageRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    // Create the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        
        // Fetch data for row
        let person = data[indexPath.row]
        
            cell.profileImage.image = person.profileImage
            if person.profileImage == nil {
                print("nil")
            }
        
        cell.name.text = person.firstName + " " + person.lastName
        cell.service.text = person.service
        cell.price.text = "$" + person.price
        cell.contact.text = person.contact
            
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Make the first row larger to accommodate a custom cell.
      if indexPath.row == 0 {
          return 80
       }

       // Use the default size for all other rows.
       return UITableView.automaticDimension
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
