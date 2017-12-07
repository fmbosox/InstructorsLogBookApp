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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let index = selectedIndex {
             setLogInformation(with: InstructorRecords.instance.info[index])
        }
        
    }

    func setLogInformation(with log:SessionLog) {
        
        switch log.type {
        case .GAP: sessionTypeSegmentedControl.selectedSegmentIndex = 0
        case .MAT: sessionTypeSegmentedControl.selectedSegmentIndex = 1
        case .CANCELLED : sessionTypeSegmentedControl.selectedSegmentIndex = 2
        default: return
        }
        
        datePicker.date = log.date
         
    }
    
    func saveLog() {
        
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
          InstructorRecords.instance.info[index].studentsInSession = Simulate.instance.students
            
        } else {
            InstructorRecords.instance.saveNewLog( type: type, date: datePicker.date, studentsInSession: Simulate.instance.students)
        }
    
        
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind" else { return }
         saveLog()
    }

    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //FALTA HACER EL UNWIND DE X hacia el RecordsViewController, cambiarlo.
    

}
