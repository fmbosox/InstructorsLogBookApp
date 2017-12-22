//
//  AddEditLogViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/3/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditLogViewController: UIViewController {
    @IBOutlet weak var sessionTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedIndex: Int?
    
    var students: [Student] = []
    
    // In case RecordsViewController passes a Index this ViewController has to set the initial information based on the Log that the users wants to see, using the following method
    func setLogInformation(with log:SessionLog) {
        switch log.type {
        case .GAP: sessionTypeSegmentedControl.selectedSegmentIndex = 0
        case .MAT: sessionTypeSegmentedControl.selectedSegmentIndex = 1
        case .CANCELLED : sessionTypeSegmentedControl.selectedSegmentIndex = 2
        default: return
        }
        datePicker.date = log.date
        students = log.studentsInSession
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = selectedIndex {
            setLogInformation(with: InstructorRecords.instance.info[index])
        }
    }
    
    //This method is called when we want to create and save a new log or when we want to commit and submit the changes of one of the objects in the array.
    func saveLogInformation() {
        let type: SessionType!
        switch sessionTypeSegmentedControl.selectedSegmentIndex {
            case 0: type = SessionType.GAP
            case 1: type = SessionType.MAT
            case 2: type = SessionType.CANCELLED
            default: return
            }
        
         if let index = selectedIndex {
          InstructorRecords.instance.info[index].date = datePicker.date
          InstructorRecords.instance.info[index].type = type
          InstructorRecords.instance.info[index].studentsInSession = students
            
            InstructorRecords.instance.saveEdited(index)
        } else {
            InstructorRecords.instance.saveNewLog( type: type, date: datePicker.date, studentsInSession: students)
        }
    }
    
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard segue.identifier == "AddStudentsSegue" else { return }
        let NavigationController = segue.destination as! UINavigationController
        let destination = NavigationController.childViewControllers.first as! StudentsSelectionViewController
        destination.students = students
     }
 
    @IBAction func unwindToAddEditLogViewController (segue: UIStoryboardSegue ){
            print("Check if anything changed......")
        print(datePicker.date)
        if segue.identifier == "UnwindToAcceptSave" {
            saveLogInformation()
            performSegue(withIdentifier: "SaveUnwind", sender: nil)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
