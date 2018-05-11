//
//  AddNewLogViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 4/3/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class AddNewLogViewController: UIViewController {

        
        //MARK: Variables
    var cancelSessionMode: Bool = false
    @objc func toggleX(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            saveSessionButton.isEnabled = false
            if !cancelSessionMode {
                sessionTypeSegmentedControl.tintColor = #colorLiteral(red: 0.6588235294, green: 0.3058823529, blue: 0.2784313725, alpha: 1)
                sessionTypeSegmentedControl.setTitle("XGAP", forSegmentAt: 0)
                sessionTypeSegmentedControl.setTitle("XMAT", forSegmentAt: 1)
                sessionTypeSegmentedControl.setTitle("XAERO", forSegmentAt: 2)
            } else  {
                sessionTypeSegmentedControl.tintColor = #colorLiteral(red: 0.1960784314, green: 0.3921568627, blue: 0.6078431373, alpha: 1)
                sessionTypeSegmentedControl.setTitle("GAP", forSegmentAt: 0)
                sessionTypeSegmentedControl.setTitle("MAT", forSegmentAt: 1)
                sessionTypeSegmentedControl.setTitle("AERO", forSegmentAt: 2)
            }
        case .ended:
                    cancelSessionMode = !cancelSessionMode
                    saveSessionButton.isEnabled = true
                    toggleButtons()
            default: break
        }
    }
    
    @IBOutlet weak var sessionTypeSegmentedControl: UISegmentedControl! {
        didSet{
            let holdDownGesture = UILongPressGestureRecognizer(target: self, action: #selector(toggleX(gesture:)))
            sessionTypeSegmentedControl.addGestureRecognizer(holdDownGesture)
        }
    }
        @IBOutlet weak var datePicker: UIDatePicker!
        @IBOutlet weak var addStudentsButton: UIButton!
        @IBOutlet weak var saveSessionButton: UIButton!
    
    
    @objc func goToPreviousVC () {
      self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var optOutView: UIView! {
        didSet{
            let touchEvent = UITapGestureRecognizer(target: self, action: #selector(goToPreviousVC))
            optOutView.addGestureRecognizer(touchEvent)
        }
    }
    
    
        var students: [Student] = []
        
        //MARK: Initial Setup
    
        override func viewDidLoad() {
            super.viewDidLoad()
            addStudentsButton.isHidden = false
            saveSessionButton.isHidden = true
            saveSessionButton.isEnabled = false
        }
        
        //MARK: Saving a Log
        
        /*This method is called when we want to create and save a new log,
         or when we want to commit and submit the changes of one of the objects in the array.
         */
        func saveLogInformation() {
            let type: SessionType!
            switch sessionTypeSegmentedControl.selectedSegmentIndex {
            case 0: type = !cancelSessionMode ? SessionType.GAP : SessionType.CANCELLED_GAP
            case 1: type = !cancelSessionMode ? SessionType.MAT : SessionType.CANCELLED_MAT
                            students = []
            case 2: type = !cancelSessionMode ? SessionType.AERO : SessionType.CANCELLED_AERO
            default: fatalError()
            }
            
            if cancelSessionMode {
                students = []
            }
            InstructorRecords.instance.saveNewLog( type: type, date: datePicker.date, studentsInSession: students)
        }
        
        // MARK: - Navigation
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == "Add Students" else { return }
            let NavigationController = segue.destination as! UINavigationController
            let destination = NavigationController.childViewControllers.first as! StudentsSelectionViewController
            destination.students = students
        }
    
    
        func toggleButtons() {
            saveSessionButton.backgroundColor = !cancelSessionMode ? #colorLiteral(red: 0.1960784314, green: 0.3921568627, blue: 0.6078431373, alpha: 1) : #colorLiteral(red: 0.6588235294, green: 0.3058823529, blue: 0.2784313725, alpha: 1)
            if sessionTypeSegmentedControl.selectedSegmentIndex != 1 && !cancelSessionMode {
                addStudentsButton.isHidden =  !students.isEmpty
            } else {
                addStudentsButton.isHidden = true
            }
            saveSessionButton.isHidden =  !addStudentsButton.isHidden
            saveSessionButton.isEnabled = sessionTypeSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment ? true : false
        }
    
    
        @IBAction func unwindToAddNewLogVC(segue: UIStoryboardSegue) {
           // get the students from students selection.
            print("I am back with \(students.count) students")
            print(students.forEach {  print($0.name) })
            toggleButtons()
        }
    
        
        // MARK: - User interaction methods
        

        @IBAction func valueChangedInSegmentedControl(_ sender: UISegmentedControl) {
            toggleButtons()
        }
    
        @IBAction func saveSessionButtonPressed(_ sender: Any) {
            saveLogInformation()
            performSegue(withIdentifier: "SaveUnwind", sender: nil)
        }
    
        @IBAction func addStudentsButtonPressed(_ sender: Any) {
           print("Segue to get students")
        }
        
}


