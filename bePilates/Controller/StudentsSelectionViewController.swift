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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SaveLogButtonStatus: UIButton!
    @IBOutlet weak var addStudentButtonStatus: UIButton!
    
    var students: [Student] = []
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "UnwindToAcceptSave" {
                saveStudentsInSession()
               let destination = segue.destination as! AddEditLogViewController
                destination.students = students
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
        navigationItem.leftBarButtonItem!.isEnabled = !navigationItem.leftBarButtonItem!.isEnabled
        tableView.setEditing(!tableView.isEditing, animated: true)
        addStudentButtonStatus.isHidden = !tableView.isEditing
        SaveLogButtonStatus.isHidden = !addStudentButtonStatus.isHidden
        if !addStudentButtonStatus.isHidden{
            sender.title = "Done"
            sender.style = .done
        } else {
            sender.title = "Edit"
            sender.style = .plain
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
