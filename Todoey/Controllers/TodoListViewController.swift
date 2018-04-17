//
//  ViewController.swift
//  Todoey
//
//  Created by Bora Dincer on 4/10/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        
        /* To delete from core item, call context.save to commit.
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        */
        
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
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    
     //Mark Save Items
    func saveItems(){
        
        do{
           try context.save()
        }catch{
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
    }
    
    //Mark Load Data 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
   
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from Context\(error)")
            
        }
        tableView.reloadData()
    }
}

//Mark SearchBar Method
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
           
        }
    
    }
}
