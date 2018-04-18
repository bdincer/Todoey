//
//  ViewController.swift
//  Todoey
//
//  Created by Bora Dincer on 4/10/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
          loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var colorPassed: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.separatorStyle = .none
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.colour else { fatalError()}
            guard let navbar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            

            guard let  navBarColor = UIColor(hexString: colorHex) else { fatalError()}
        
            title = selectedCategory?.name
                navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
                navbar.barTintColor = navBarColor
                navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
         navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
        
    }

    //Mark tableview Data Sources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
           
            print("colorPassed: \(self.colorPassed)")
        
            let c = UIColor(hexString: colorPassed)
           
            if let color = c?.darken(byPercentage:(CGFloat(indexPath.row)/CGFloat(todoItems!.count))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //value = condition ? valueifTrue :valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
              cell.textLabel?.text =  "No Items Added"
        }
        return cell
        
    }
    
    //Mark TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print ("Error saving done\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark Add new Items

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add item
          
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                   print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
     //Mark Save Items
    func saveItems(item: Item){
        
        do{
            try realm.write {
                realm.add(item)
            }
        }catch{
            print("Error saving Realm\(error)")
        }
        
        tableView.reloadData()
    }
    
    //Mark Load Data
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error\(error)")
            }
        }
    }
}

////Mark SearchBar Method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
