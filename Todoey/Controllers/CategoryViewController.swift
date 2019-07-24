//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Fadli Al Baihaqi on 19/07/19.
//  Copyright © 2019 Fadli Al Baihaqi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categoryColor = categories?[indexPath.row].color {
            cell.backgroundColor = UIColor(hexString: categoryColor)
        } else {
            let categoryColor = UIColor.randomFlat
            cell.backgroundColor = categoryColor
            updateColorCategories(category: categories?[indexPath.row], color: categoryColor.hexValue())
        }
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories add here!"

        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            // what will happen once the user click the Add Item buttton on UI Alert
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Load Categories
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
    // MARK: - Update Categories
    func updateColorCategories(category: Category?,color hexString: String) {
        if let item = category {
            do {
                try realm.write {
                    item.color = hexString
                }
            } catch {
                print("Error updating color, \(error)")
            }
        }
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                    DispatchQueue.main.async {
                        self.loadCategories()
                        self.tableView.resignFirstResponder()
                    }
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            
            let destinationVC = segue.destination as! ToDoListViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}
