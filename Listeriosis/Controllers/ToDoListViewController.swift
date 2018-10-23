//
//  ViewController.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/16.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Items]()
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        if let  items = defaults.array(forKey: "ListeriosisArray") as? [String] {
        //            itemArray = items
        
        
        
        //        if let items = defaults.array(forKey: "ListeriosisArray") as? [Item] {
        //            itemArray = items
        //        }
        
    }
    
    //MARK:  - TableView Datasource Methods
    
    
    //How many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Create a new reusable cell with name from storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator ===>
        //value = condition ? ValueIfTrue : ValueifFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Tableview Delegate methods
    
    //what happens when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new Items
    @IBAction func addListItemButton(_ sender: UIBarButtonItem) {
        
        //creates an alert
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        //create bigger scope textfield variable
        
        var textField = UITextField()
        
        //creates an action to take on alert button press
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens once user clicks add item button on UIAlert
            
            
            
            let newItem = Items(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveData()
            
        }
        //Add textfield to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        //calls new alert and adds action to it
        alert.addAction(action)
        
        
        
        //presents alert when action is pressed
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveData(){
        
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadData(with request: NSFetchRequest<Items> = Items.fetchRequest(), predicate: NSPredicate? = nil){
        
     //   let request : NSFetchRequest<Items> = Items.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
      //  let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
     //   request.predicate = compoundPredicate
        
        do {
          itemArray =  try  context.fetch(request)
        }catch{
            print("Error loading context \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //create data fetch request
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        //create a filter via nspredicate
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //apply filter to request
        //request.predicate = predicate
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //create sort via nssortdiscriptor
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        //apply sort to request
//        request.sortDescriptors = [sortDescriptor]
//
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]


        //fetch data
//        do {
//            itemArray =  try  context.fetch(request)
//        }catch{
//            print("Error loading context \(error)")
//        }
        
        loadData(with: request, predicate: predicate)
        
        //reload data view
        //tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
    }
}
