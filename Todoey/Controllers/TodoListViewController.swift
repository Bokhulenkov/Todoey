//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK: - Action
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            
            //            инициализируем объект базы данных
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? " "
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    
    // MARK: - Table View DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.selectionStyle = .none
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        удаляем элемент из контекста
        context.delete(itemArray[indexPath.row])
//        удаляем из списка элементов
        itemArray.remove(at: indexPath.row)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    }
    
    // MARK: - Encoder
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error savign context \(error)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Load Data
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error load \(error)")
        }
    
        tableView.reloadData()
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        смотрим содержит ли атрибут title значение %@ из searchBar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? " ")
        
        request.predicate = predicate
        
//        сортируем полученные данные
        let sortDesctiptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDesctiptor]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                //           возврат в исходное состояние
                searchBar.resignFirstResponder()
            }
        }
    }
}


