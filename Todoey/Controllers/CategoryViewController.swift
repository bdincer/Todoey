//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bora Dincer on 4/16/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?  //this is realm cotainer that holds the objects.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.separatorStyle = .none
        

    }
    
    // MARK: - Table View Data Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            destinationVC.colorPassed = (categoryArray?[indexPath.row].colour)!
            
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].colour ?? "1D9BF6")
        return cell
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            //what will happen when user clicks add item
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving Realm\(error)")
        }
        
        tableView.reloadData()
    }
    
    // Mark: Load Data
    func loadCategory(){

        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //Mark Delete for Swip
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categoryArray?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }
            catch {
                print("Error\(error)")
            }
        }
    }
    

}

