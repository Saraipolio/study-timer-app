//
//  ToDoTableViewController.swift
//  TodoList
//
//  Created by Student on 04/17/23.
//

import UIKit
//view for the To Do Table View
class ToDoTableViewController: UITableViewController {
    var toDoCDs: [ToDoCD] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //get the to do items!
    func getToDos(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let toDosFromCoreData = try? context.fetch(ToDoCD.fetchRequest()){
                if let toDos = toDosFromCoreData as? [ToDoCD]{
                    toDoCDs = toDos
                    tableView.reloadData()
                }
            }
        }
    }
    //when the view appears, get the to do items
    override func viewWillAppear(_ animated: Bool){
        getToDos()
    }
    
    // MARK: - Table view data source
    //the number of rows in our table view is the amount of todo items we have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoCDs.count
    }

    //what each cell within the table view returns
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let selectedToDo = toDoCDs[indexPath.row]
        
        //show the priority in the text
        if selectedToDo.priority == 1 {
            if let name = selectedToDo.name{
                cell.textLabel?.text = "❗️" + name
            }
        }
        else if selectedToDo.priority == 2 {
            if let name = selectedToDo.name{
                cell.textLabel?.text = "‼️" + name
            }
        }
        else {
            if let name = selectedToDo.name{
                cell.textLabel?.text = name
            }
        }
        return cell
    }
    //when a cell in the table view is selected, move to the details view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedToDo = toDoCDs[indexPath.row]
        performSegue(withIdentifier: "moveToDetails", sender: selectedToDo)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                let selectedToDo = toDoCDs[indexPath.row]
                context.delete(selectedToDo)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                getToDos()
            }
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //our segue destinations 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addToDoViewController = segue.destination as? AddToDoViewController {
            addToDoViewController.toDoTableViewController = self
        }
        if let detailsToDoViewController = segue.destination as? ToDoDetailsViewController{
            if let selectedToDo = sender as? ToDoCD{
                detailsToDoViewController.toDoCD = selectedToDo
            }
        }
    }
}
