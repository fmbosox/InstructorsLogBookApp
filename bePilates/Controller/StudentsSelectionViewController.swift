//
//  StudentsSelectionViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/6/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class StudentsSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SaveLogButtonStatus: UIButton!
    @IBOutlet weak var addStudentButtonStatus: UIButton!
    
    var students: [Student] = []
    var oneTimeEvent = false  //When this property is set to true it prevents the call of setStudentsInSessionCheckmark(_ indexPath: IndexPath) -> UITableViewCellAccessoryType.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Saves the students in the context of the current Log, a Student is added if the cell view has the accessoryType Checkmark
    func saveStudentsInSession() {
        students.removeAll()
        if let unwrappedIndexPathArray = tableView.indexPathsForVisibleRows {// bug here
            for indexPath in unwrappedIndexPathArray{
                if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                      students.append(StudentsManager.instance.info[indexPath.row])
                }
            }
        }
    }
    
    //If a Log is being edited this method helps to set the checkmark to the corresponding studentinSession.
    func setInitialCheckmark(_ indexPath: IndexPath) -> UITableViewCellAccessoryType {
        for aStudent in students {
                    if aStudent.id == StudentsManager.instance.info[indexPath.row].id {
                        return .checkmark
                    }
                }
        return .none
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
            oneTimeEvent = false
                tableView.reloadData()
        }
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
       // navigationItem.rightBarButtonItem?.title = "Done"   BUG Here
        addStudentButtonStatus.isHidden = !tableView.isEditing
        SaveLogButtonStatus.isHidden = !addStudentButtonStatus.isHidden
    }
 
}

extension StudentsSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  StudentsManager.instance.info.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.textLabel?.text = StudentsManager.instance.info[indexPath.row].name + " " + StudentsManager.instance.info[indexPath.row].lastName
        if !oneTimeEvent {
            cell.accessoryType = setInitialCheckmark(indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        oneTimeEvent = true
        if editingStyle == UITableViewCellEditingStyle.delete {
            StudentsManager.instance.info.remove(at: indexPath.row)
           tableView.reloadData()
        
        }
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAStudentSegue", sender: indexPath)
    }

}
