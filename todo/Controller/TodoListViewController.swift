//
//  ViewController.swift
//  todo
//
//  Created by shen cheer on 10/03/2018.
//  Copyright © 2018 shen cheer. All rights reserved.
// chflags nohidden ~/Library
// /Users/shencheer/Library/Developer/Xcode/DerivedData/Todoey-excnvjyqzsnyfeddlwrkomqafbtv/Build/Intermediates.noindex/Todoey.build/Debug-iphonesimulator/Todoey.build


import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["1","2","3"]
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
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
            print("success")
            let newItem = Item()
            newItem.title = textfied.text!
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
        let encoder = PropertyListEncoder()
        do{
            let  data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
            
        {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print (error)
            }
        }
    }
    
}

