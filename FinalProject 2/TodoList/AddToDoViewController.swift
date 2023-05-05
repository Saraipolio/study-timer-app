//
//  AddToDoViewController.swift
//  TodoList
//
//  Created by Student on 04/17/23.
//

import UIKit

// the code for the View that adds to the Table View
class AddToDoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var toDoTableViewController: ToDoTableViewController?=nil
    //create outlets to our objects
    @IBOutlet weak var timerToDo: UIPickerView!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    //instantiate variables
    var selectedHour = 0
    var selectedMinute = 0
    var selectedDayIndex = 0
    
    //load the view
    override func viewDidLoad() {
        super.viewDidLoad()
        timerToDo.delegate = self
        timerToDo.dataSource = self
    }
    
    //when the add button is tapped
    @IBAction func addTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let newToDo = ToDoCD(context: context)
                newToDo.priority = Int32(prioritySegment.selectedSegmentIndex)
                
                if let name = nameTextField.text {
                    newToDo.name = name
                }
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            
            navigationController?.popViewController(animated: true)
        }
    //return two components in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 2
   }
    //the amount of rows in the picker view (based on time)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return 24
            } else {
                return 60
            }
        }
    //what happens when the rows are selected in the pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //set varibles to use in the nameTextField function that appends the time to it
        let selectedHours = pickerView.selectedRow(inComponent: 0)
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        let timeString = String(format: "%02d:%02d", selectedHours, selectedMinute)
        if nameTextField.text?.isEmpty ?? true {
            nameTextField.text = timeString
        } else {
            nameTextField.text?.append(" " + timeString)
        }
    }
    //the title for each row in the picker view.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) hours"
        } else {
            return "\(row) minutes"
        }
   }
}
