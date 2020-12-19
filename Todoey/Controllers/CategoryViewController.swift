//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mai Xuan Linh on 16.12.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
        
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Nav Bar Does not Exist!")
        }
        
        navBar.backgroundColor = UIColor(hexString:  "00B06B")
        
    }
    
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
  
      
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
              
            
    
            self.saveItems(category: newCategory)
       
            
         
         
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
    
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
           
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
       
        return cell
    

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
 
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
//
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(indexPath.row)
      performSegue(withIdentifier: "goToItems", sender: self)



    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
       


       }
    
    func saveItems(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving context")
        }
     
        
    }
    
    //Delete data from Swipe
  
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
                
            } catch {
                print("Error deleting category, \(error)")
            }
    
            
        }
    }
    
    
    
    

 

}

//MARK: - Swipe Cell Delegate Methods

