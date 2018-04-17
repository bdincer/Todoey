//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bora Dincer on 4/16/18.
//  Copyright © 2018 Bora Dincer. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    // MARK: - Table View Data Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            //what will happen when user clicks add item
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
           
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
    }
    
    //Mark Load Data
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching data from Context\(error)")
            
        }
        tableView.reloadData()
    }
    

}
