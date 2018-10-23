//
//  CategoryViewController.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/23.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textfield.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveData()
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
        return categoryArray.count
    }
    
    
    //create cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
      //  let categoryItem = categoryArray[indexPath.row]
        
      //  catCell.textLabel?.text = categoryItem.name
        
        catCell.textLabel?.text = categoryArray[indexPath.row].name
        
        return catCell
    }
    
    
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
         categoryArray = try context.fetch(request)
        }catch {
            print("Load data failed with: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        
        do {
            try context.save()
        }catch{
            print("Error saving data with: \(error)")
        }
        tableView.reloadData()
    }
    
    //
    
}
