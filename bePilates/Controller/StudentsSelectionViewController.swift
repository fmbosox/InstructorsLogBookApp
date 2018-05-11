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
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar! 
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var studentsToShow: [Student] = StudentsManager.instance.info
    var students: [Student] = []
    var onlyViewFlag = false
    var studentsInSaveBuffer: [Student] = []
    
    // MARK: - Initial Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    //MARK: - Adding & Removing students to a Log.
    
    /*Saves the students in the context of the current Log,
    a Student is added if the cell view has the accessoryType Checkmark
    */
    func saveStudentsInSession() {
        students.removeAll()
        for value in studentsInSaveBuffer {
            students.append(value)
        }
        studentsInSaveBuffer.removeAll()
    }
    
    
    
    /*If a Log is being edited,
     this method helps to set the checkmark to the corresponding studentinSession.
     */
    func removeValueFromBuffer(for row: Int) {
        let index = studentsInSaveBuffer.index { (aStudent) -> Bool in
            aStudent.id == studentsToShow[row].id
        }
        if let index = index {
            studentsInSaveBuffer.remove(at: index)
        }
        
        
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "Unwind to Session VC" {
                saveStudentsInSession()
               let destination = segue.destination as? AddNewLogViewController
                destination!.students = students
        }
     }
    
    // MARK: - User interaction methods

    
}
    
    


    // MARK: - Table view config

extension StudentsSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setAccesoryType(for indexPath: IndexPath) -> UITableViewCellAccessoryType{
       return studentsInSaveBuffer.map { $0.id }.contains(studentsToShow[indexPath.row].id)    ?   .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  studentsToShow.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        cell.accessoryType = setAccesoryType(for: indexPath)
        
        cell.textLabel?.text = studentsToShow[indexPath.row].name + " " + studentsToShow[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !onlyViewFlag else { return }
        
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                removeValueFromBuffer(for: indexPath.row)
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                studentsInSaveBuffer.append(studentsToShow[indexPath.row])
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

}






extension StudentsSelectionViewController:  UISearchBarDelegate {
 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            studentsToShow = StudentsManager.instance.info
        } else {
            print("searchBar text did change")
            studentsToShow = StudentsManager.instance.info.filter({ (aStudent) -> Bool in
                aStudent.name.contains(searchText)
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("SearchBar text end editign")
        if studentsToShow.count != StudentsManager.instance.info.count {
             studentsToShow = StudentsManager.instance.info
              tableView.reloadData()
        }
       
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button tapped")
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped")
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
       
    }
    
    
    
}

