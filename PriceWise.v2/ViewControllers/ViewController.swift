//
//  ViewController.swift
//  PriceWise.v2
//
//  Created by Marlon Noble on 12/4/23.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var items: [Item] = [] // Array to store fetched Firestore data

    // Define your data source for the table view
    let dataArray = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView = UITableView(frame: view.bounds, style: .plain)
    // Register the cell identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "YourCellIdentifier")
        tableView.dataSource = self // Set table view data source
        tableView.reloadData() // Reload table view initially
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataArray.count
        return items.count // Number of rows in the table view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourCellIdentifier", for: indexPath)
        let item = items[indexPath.row]
        // Configure the cell with item data
        cell.textLabel?.text = String(item.itemName)
        cell.detailTextLabel?.text = "Item Name: \(item.itemName), Price: \(item.price), Quantity: \(item.quantity), Unit: \(item.unit)"
        // Customize cell as needed
        return cell
    }
    
    func fetchData() {
        // Access Firestore
        let db = Firestore.firestore()
        // Reference to the "users" collection
        let itemsCollection = db.collection("items")
        // Fetch documents from Firestore
        itemsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Clear existing data
                self.items.removeAll()
                // Parse fetched data and populate 'items' array
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let id = data["id"] as? Int,
                       let itemName = data["itemName"] as? String,
                       let price = data["price"] as? Int,
                       let quantity = data["quantity"] as? Int,
                       let unit = data["unit"] as? String{
                       let item = Item(id: id, itemName: itemName, price: price, quantity: quantity, unit: unit)
                        self.items.append(item)
                    }
                }
                // Reload table view to display fetched data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        
        }
    }
}


// Your data model structure
  struct Item {
      let id: Int
      let itemName: String
      let price: Int
      let quantity: Int
      let unit: String
      // Add other properties as needed
  }
