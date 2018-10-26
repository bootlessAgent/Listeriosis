//
//  CategoryViewController.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/23.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        loadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textfield.text!
            
            self.saveData(category:newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Data Source Methods
    
    //Create Tableview Bounds
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    //create cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
      //  let categoryItem = categoryArray[indexPath.row]
        
      //  catCell.textLabel?.text = categoryItem.name
        
        catCell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        return catCell
    }
    
    
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func loadData(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func saveData(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving data with: \(error)")
        }
        tableView.reloadData()
    }
    
    //
    
}
