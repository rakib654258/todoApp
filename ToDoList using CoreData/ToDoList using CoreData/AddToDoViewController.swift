//
//  AddToDoViewController.swift
//  ToDoList using CoreData
//
//  Created by macOS Mojave on 3/5/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {
    
    var previousVC = ViewController()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationBar Large title 
        navigationItem.largeTitleDisplayMode = .never

    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        //Working AddToDo List without CoreData
      /*  let toDo = ToDo()
        toDo.iteam = textField.text!
        toDo.important = switchLabel.isOn
        
        previousVC.toDos.append(toDo)
        previousVC.tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
 */
        //MARK: Save data into coredata
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let toDo = ToDoCoreData(entity: ToDoCoreData.entity(), insertInto: context)
            
            if let iteam = textField.text{
                toDo.name = iteam
                toDo.important = switchLabel.isOn
            }
            // save date into coredata from datepicker
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy"
//            toDo.date = formatter.string(from: datePicker.date)
            
            toDo.date = datePicker.date
            print(datePicker.date)
            try? context.save()
            navigationController?.popViewController(animated: true)
        }
    }
    
}
