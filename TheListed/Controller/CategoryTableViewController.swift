//
//  CategoryTableViewController.swift
//  TheListed
//
//  Created by Дмитро Волоховський on 16/11/2021.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count}
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destignationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destignationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
               
        return cell
    }

    
    
//MARK - Add new Categories.
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Category ", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { action in
                
                let newICategory = Category(context: self.context)
                newICategory.name = textField.text!
                self.categoryArray.append(newICategory)
                
                self.saveItems()
                
                self.tableView.reloadData()
            }
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Create Something New"
                textField = alertTextField
                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    
    
    func loadCategories (with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray =  try context.fetch(request)
            
        }catch {
            print (error)
        }
        tableView.reloadData()
    }
    func saveItems(){
        do{
           try self.context.save()
        }catch{
            print("We have an arrror abort the mission")
        }
    }
}

