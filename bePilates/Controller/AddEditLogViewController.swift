//
//  AddEditLogViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/3/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditLogViewController: UIViewController {
    
        //MARK: Variables
    
    @IBOutlet weak var cancelledSessionSwitch: UISwitch!
    @IBOutlet weak var sessionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addStudentsButton: UIButton!
    @IBOutlet weak var cancelSessionButton: UIButton!
    
    var selectedIndex: Int?
    var students: [Student] = []
    
      //MARK: Initial Setup
    
    /* In case RecordsViewController passes an Index, AddEditLogViewController has to set the initial information based on the Log
        that the users wants to see, using the following method
    */
    func setLogInformation(with log:SessionLog) {
       // recordLabel.text = "Record Info"
        switch log.type as SessionType {
        case .GAP, .CANCELLED_GAP: sessionTypeSegmentedControl.selectedSegmentIndex = 0
        case .MAT, .CANCELLED_MAT: sessionTypeSegmentedControl.selectedSegmentIndex = 1
        case .AERO, .CANCELLED_AERO: sessionTypeSegmentedControl.selectedSegmentIndex = 2
        }
        if  log.type == .CANCELLED_GAP || log.type == .CANCELLED_MAT{
            cancelSessionButton.isHidden = false
            addStudentsButton.isHidden = !cancelSessionButton.isHidden
            cancelledSessionSwitch.isOn = true
        } else {
            cancelSessionButton.isHidden = true
            addStudentsButton.isHidden = !cancelSessionButton.isHidden
            addStudentsButton.setTitle("VIEW STUDENTS", for: UIControlState.normal)
        }
        datePicker.date = log.date
        students = log.studentsInSession
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let index = selectedIndex {
            setLogInformation(with: InstructorRecords.instance.info[index])
        } else {
            addStudentsButton.isHidden = true
            cancelSessionButton.isHidden = true
        }
    }
    
    //MARK: Saving a Log
    
    /*This method is called when we want to create and save a new log,
     or when we want to commit and submit the changes of one of the objects in the array.
     */
    func saveLogInformation() {
        let type: SessionType!
        switch sessionTypeSegmentedControl.selectedSegmentIndex {
            case 0: type = !cancelledSessionSwitch.isOn ?    SessionType.GAP :  SessionType.CANCELLED_GAP
            case 1: type =  !cancelledSessionSwitch.isOn ?    SessionType.MAT :  SessionType.CANCELLED_MAT
            case 2: type =  !cancelledSessionSwitch.isOn ?    SessionType.AERO :  SessionType.CANCELLED_AERO
            default: fatalError()
            }
        
         if let index = selectedIndex {
          InstructorRecords.instance.info[index].date = datePicker.date
          InstructorRecords.instance.info[index].type = type
            InstructorRecords.instance.info[index].studentsInSession =  !cancelledSessionSwitch.isOn ?  students : []
            
            InstructorRecords.instance.saveEdited(index)
        } else {
            InstructorRecords.instance.saveNewLog( type: type, date: datePicker.date, studentsInSession:  !cancelledSessionSwitch.isOn ?  students : [])
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
    
    // MARK: - User interaction methods
    
    func enableButton() {
        addStudentsButton.isHidden =  !cancelledSessionSwitch.isOn ? false : true
        cancelSessionButton.isHidden =  cancelledSessionSwitch.isOn ? false : true
    }
    
    @IBAction func valueChangedInSegmentedControl(_ sender: UISegmentedControl) {
        enableButton()
    }
    
        @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        cancelledSessionSwitch.isOn = sender.isOn
     if sessionTypeSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment {
          enableButton()
        }
    }

    @IBAction func cancelSessionButtonPressed(_ sender: Any) {
        saveLogInformation()
        performSegue(withIdentifier: "SaveUnwind", sender: nil)
    }
    
}
