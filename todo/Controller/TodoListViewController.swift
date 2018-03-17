//
//  ViewController.swift
//  todo
//
//  Created by shen cheer on 10/03/2018.
//  Copyright © 2018 shen cheer. All rights reserved.
// chflags nohidden ~/Library
// /Users/shencheer/Library/Developer/Xcode/DerivedData/Todoey-excnvjyqzsnyfeddlwrkomqafbtv/Build/Intermediates.noindex/Todoey.build/Debug-iphonesimulator/Todoey.build


import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["1","2","3"]
    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let   cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print([indexPath.row])
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        context.delete(itemArray[indexPath.row]) //first
        itemArray.remove(at: indexPath.row) //second
        self.saveItem()
        //tableView.reloadData()
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK addButtonPress
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textfied = UITextField()
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textfied.text!
            newItem.done = false
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "todoListArray")
            self.saveItem()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfied = alertTextField
            print(textfied.text)
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItem()
    {
        do{
            try context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest())
    {
        
        do{
         itemArray = try context.fetch(request)
        }
        catch {
            print("loadItems\(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        //https://academy.realm.io/posts/nspredicate-cheatsheet/
        //http://nshipster.com/nspredicate/
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with:request)
//        do{
//            itemArray = try context.fetch(request)
//        }
//        catch {
//            print("loadItems\(error)")
//        }
        
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//
//        tableView.reloadData()
        
    }
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
}

