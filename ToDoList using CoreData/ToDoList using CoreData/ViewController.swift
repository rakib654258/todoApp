//
//  ViewController.swift
//  ToDoList using CoreData
//
//  Created by macOS Mojave on 3/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var toDos : [ToDoCoreData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigation bar large title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        //toDos = createToDos()
        //getCoreData()
    }
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
    }
    
    func getCoreData(){
        // MARK: Fetch the data from coreData
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            if let coreDataToDos = try? context.fetch(ToDoCoreData.fetchRequest()) as? [ToDoCoreData]{
                if let theToDos = coreDataToDos {
                    toDos = theToDos
                    tableView.reloadData()
                }
                
            }
            
            
        }
    }
//    func createToDos() -> [ToDo]{
//        let eggs = ToDo()
//        eggs.iteam = "Buy Eggs"
//        eggs.important = true
//
//        let milk = ToDo()
//        milk.iteam = "Buy milk 1 litter"
//
//        return [eggs, milk]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! customTableViewCell
        let toDo = toDos[indexPath.row]
        if toDo.important{
            cell.iteamLabel.text = "⭐️" + toDo.name!
            if let date = toDo.date{
                cell.dateLabel.text = "End Task: " + "\(date)"
            }
        }
        else{
            cell.iteamLabel.text = toDo.name
            if let date = toDo.date{
                cell.dateLabel.text = "End Task: " + "\(date)"
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = toDos[indexPath.row]
        performSegue(withIdentifier: "completeSegue", sender: toDo)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddToDoViewController{
            addVC.previousVC = self
        }
        if let completeVC = segue.destination as? CompleteToDoViewController{
            if let toDo = sender as? ToDoCoreData{
                completeVC.selectedToDo = toDo
                completeVC.previousVC = self
            }
        }
    }
    // Swipe Action in tableView Cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func deleteAction(at indexpath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.toDos.remove(at: indexpath.row)
            self.tableView.deleteRows(at: [indexpath], with: .automatic)
            completion(true)
            
            //delete from coredata
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                if let theToDo = self.toDos[indexpath.row] {
                    context.delete(theToDo)
                    try? context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
            ///
            
        }
        //action.image = tash
        action.backgroundColor = .red
        
        return action
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.toDos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        //action.image = tick
        action.backgroundColor = .green
        //action.textColor = .black
        
        return action
    }
}

