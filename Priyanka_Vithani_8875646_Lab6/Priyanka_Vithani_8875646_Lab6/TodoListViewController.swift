//
//  TodoListViewController.swift
//  Priyanka_Vithani_8875646_Lab6
//
//  Created by Priyanka Vithani on 16/10/23.
//

import UIKit

class TodoListViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variables
    var todoItems: [String]? = ["Table view to list the to do items", "A button to add an item to the list.", "Once the user clicks the add button (2) a fill form is displayed in the screen", "A text field to write an item. ", "The user can confirm the item.", "The user can cancel the item.", "The user can delete an item by swapping it.", "All added items should be stored and can be retrieved even if the app is terminated.", "Deleted items should be removed from the permanent storage.", "You should write a clean code and follow/use the proper naming convention"]
    
    //MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todoList = UserDefaults.standard.array(forKey: "ToDoItems") as? [String]{
            todoItems = todoList
        }
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    //MARK: Add Item Button Action
    @IBAction func AddTodoListItem(_ sender: UIBarButtonItem) {
        ShowAlert(isEdit: false, index: 0)
    }
    
    //MARK: Methods
    func ShowAlert(isEdit:Bool, index:Int){
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            if isEdit{
                textField.text = self.todoItems?[index]
            }else{
                textField.placeholder = "Write an item"
            }
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            if isEdit{
                
                self.todoItems?[index] = alert.textFields?.first?.text ?? ""
            }else{
                if (self.todoItems?.count ?? 0) > 0{
                    self.todoItems?.append(alert.textFields?.first?.text ?? "")
                }else{
                    self.todoItems = [alert.textFields?.first?.text ?? ""]
                }
            }
            self.dismiss(animated: true){
                self.setUserDefault()
                self.tableview.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    func editItem(at indexPath: IndexPath) {
        ShowAlert(isEdit: true, index: indexPath.row)
    }
    func setUserDefault(){
        if let array = todoItems{
            UserDefaults.standard.set(array, forKey: "ToDoItems")
        }else{
            UserDefaults.standard.set(nil, forKey: "ToDoItems")
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        todoItems?.remove(at: indexPath.row)
        setUserDefault()
        tableview.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

//MARK: Tableview Delegate and Datasource methods
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCellTableViewCell", for: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
}
