//
//  ViewController.swift
//  Listeriosis
//
//  Created by Eugene Trumpelmann on 2018/10/16.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    let itemArray = ["Do something","Do something else","one more doing"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    //MARK:  - TableView Datasource Methods
    
    
    //How many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Create a new reusable cell with name from storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Tableview Delegate methods
    
    //what happens when cell is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
}


