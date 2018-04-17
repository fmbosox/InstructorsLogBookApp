//
//  StudentsSelectionViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/6/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class StudentsSelectionViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var doneButton: UIBarButtonItem?
    
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Student] = []
    var onlyViewFlag = false
    var studentsInSaveBuffer: [Int:Student] = [:]
    
    // MARK: - Initial Setup
    
    func setInitialStudentsBuffer() {
        for aStudent in students {
            let index = StudentsManager.instance.info.index(where: { (student) -> Bool in
                aStudent.id == student.id
            })
            if let unwrappedIndex = index {
                studentsInSaveBuffer[unwrappedIndex] = aStudent
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setInitialStudentsBuffer()
        if StudentsManager.instance.info.isEmpty {
            editButtonPressed(self.navigationItem.rightBarButtonItem!)
        }
    }

    //MARK: - Adding & Removing students to a Log.
    
    /*Saves the students in the context of the current Log,
    a Student is added if the cell view has the accessoryType Checkmark
    */
    func saveStudentsInSession() {
        students.removeAll()
        for value in studentsInSaveBuffer.values {
            students.append(value)
        }
        studentsInSaveBuffer.removeAll()
    }
    
    /*If a Log is being edited,
     this method helps to set the checkmark to the corresponding studentinSession.
    */
    func removeValueFromBuffer(forKey key: Int, update: Bool = false) {
        studentsInSaveBuffer.removeValue(forKey: key)
        if update {
            for index in key...StudentsManager.instance.info.count {
                if let aStudent = studentsInSaveBuffer.removeValue(forKey: index) {
                    studentsInSaveBuffer.updateValue(aStudent, forKey: index-1)
                }
                
            }
        }
    }

    // MARK: - Navigation
    
   // let destination: UIViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "Unwind to Session VC" {
                saveStudentsInSession()
               let destination = segue.destination as? AddNewLogViewController
                destination!.students = students
        }
        guard segue.identifier == "ShowAStudentSegue" else { return }
            let anotherDestination = segue.destination as! AddEditAStudentViewController
            let indexPath = sender as! IndexPath
            print(indexPath)
            anotherDestination.selectedIndex = indexPath.row
     }
    
    @IBAction func unwindToStudentsSelectionViewController  (segue: UIStoryboardSegue ){
        if segue.identifier == "SaveAStudentUnwind" {
                tableView.reloadData()
        }
    }
    
    // MARK: - User interaction methods

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if onlyViewFlag {
            tableView.setEditing(!tableView.isEditing, animated: true)
            
            if sender.style == .plain {
                sender.style = .done
            } else {
                sender.style = .plain
            }
            
        } else {
            navigationItem.leftBarButtonItem!.isEnabled = !navigationItem.leftBarButtonItem!.isEnabled
            tableView.setEditing(!tableView.isEditing, animated: true)
            doneButton!.isEnabled = !tableView.isEditing
            if !doneButton!.isEnabled{
                sender.style = .done
            } else {
                sender.style = .plain
            }
            
        }
        
       
    }
 
}

    // MARK: - Table view config

extension StudentsSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setAccesoryType(of aStudent: Student?) -> UITableViewCellAccessoryType{
        return aStudent != nil ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  StudentsManager.instance.info.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.accessoryType = setAccesoryType(of: studentsInSaveBuffer[indexPath.row])
        
        cell.textLabel?.text = StudentsManager.instance.info[indexPath.row].name + " " + StudentsManager.instance.info[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !onlyViewFlag else { return }
        
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                removeValueFromBuffer(forKey: indexPath.row)
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                studentsInSaveBuffer[indexPath.row] = StudentsManager.instance.info[indexPath.row]
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            StudentsManager.instance.removeAt(indexPath.row)
            removeValueFromBuffer(forKey: indexPath.row, update: true)
           tableView.reloadData()
        
        }
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAStudentSegue", sender: indexPath)
    }

}
