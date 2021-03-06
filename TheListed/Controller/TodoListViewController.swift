//
//  ViewController.swift
//  TheListed
//
//  Created by Дмитро Волоховський on 15/11/2021.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
 
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    //MARK - TableViewDelegagte metods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveItems()
        
        tableView.reloadData() 
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - AddItemsMeth
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title   = textField.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
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
    
    func saveItems(){
        do{
           try self.context.save()
        }catch{
            print("We have an arrror abort the mission")
        }
    }
    func loadItems (with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil)
    {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }else{
            request.predicate = categoryPredicate
            
        }
 
        do{
          itemArray =  try context.fetch(request)
        }catch {
            print (error)
        }
        tableView.reloadData()
    }
       }
extension TodoListViewController :UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
      
                
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@",searchBar.text!)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
        
        
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
