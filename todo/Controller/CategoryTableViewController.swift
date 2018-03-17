//
//  CategoryTableViewController.swift
//  todo
//
//  Created by shen cheer on 17/03/2018.
//  Copyright © 2018 shen cheer. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {

    ///Users/shencheer/Library/Developer/CoreSimulator/Devices/DFE8045C-83C8-4A5D-9DDA-14CC193FCFF5/data/Containers/Data/Application/B5596359-A9C4-499A-98EC-323DE9D6AECD/Documents
    var catogoryArray = [Catogory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catogoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let   cell = tableView.dequeueReusableCell(withIdentifier: "catogoryCell", for: indexPath)
        let item = catogoryArray[indexPath.row]
        cell.textLabel?.text = item.name
        
       
        return cell
    }
    
    @IBAction func cateBottumPress(_ sender: UIBarButtonItem) {
        var textfied = UITextField()
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { (action) in
            let newItem = Catogory(context: self.context)
            newItem.name = textfied.text!
            
            self.catogoryArray.append(newItem)
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
    
    func loadItems(with request:NSFetchRequest<Catogory> = Catogory.fetchRequest())
    {
        
        do{
            catogoryArray = try context.fetch(request)
        }
        catch {
            print("loadItems\(error)")
        }
        
        tableView.reloadData()
    }
}
