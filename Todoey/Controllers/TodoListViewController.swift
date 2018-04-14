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

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //print (dataFilePath)
        loadItems()
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
        saveItems()
     
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
            self.saveItems()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error during saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
           let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding\(error)")
            }
            
        }
        
    }
    
}

