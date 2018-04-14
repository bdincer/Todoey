//
//  ViewController.swift
//  Todoey
//
//  Created by Bora Dincer on 4/10/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Buy Milk"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy Shoes"
        itemArray.append(newItem3)
        
       if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
       }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    //Mark tableview Data Sources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //value = condition ? valueifTrue :valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none

        /* Replaced by Above Short Hand  Ternary Operator
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }*/
        return cell
        
    }
    
    //Mark TableView Delegate Methods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //the following line reserve the bool value, versus if else
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Mark Add new Items

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item
          
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

