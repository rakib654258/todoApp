//
//  CompleteToDoViewController.swift
//  ToDoList using CoreData
//
//  Created by macOS Mojave on 3/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class CompleteToDoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    var previousVC = ViewController()
    var selectedToDo : ToDoCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonOutlet.layer.cornerRadius = 20.0
        buttonOutlet.layer.masksToBounds = true
        
        titleLabel.text = selectedToDo?.name
    }
    
    @IBAction func completeAction(_ sender: UIButton) {
//       // Delete data
//        var index = 0
//        for toDo in previousVC.toDos{
//            if toDo.name == selectedToDo.name{
//                //print("We found it! \(toDo.iteam) \(index)")
//                previousVC.toDos.remove(at: index)
//                previousVC.tableView.reloadData()
//                navigationController?.popViewController(animated: true)
//                //break
//            }
//            index += 1
//        }
        // MARK: Delete data from coredata
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let theToDo = selectedToDo {
                context.delete(theToDo)
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
