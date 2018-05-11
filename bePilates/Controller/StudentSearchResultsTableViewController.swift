//
//  SearchResultsTableViewController.swift
//  SearchBarToy
//
//  Created by Felipe Montoya on 4/13/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class StudentSearchResultsTableViewController: UITableViewController {

    
    var studentsInSearch: [Student]?
    var onlyViewStudentFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func updateStudentsInSearch() {
        var updatedStudentsInSearch:[Student]? = []
        for aStudent in studentsInSearch! where studentsInSearch != nil {
            if let updatedStudent = StudentsManager.instance.info.first(where: { (student) -> Bool in
                return student.id == aStudent.id })
            {
                updatedStudentsInSearch?.append(updatedStudent)
            }
        }
        studentsInSearch = updatedStudentsInSearch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Updated data")
        updateStudentsInSearch()
        self.tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAStudentSegue" else { return }
        let addEditStudentVC = segue.destination as! AddEditAStudentViewController
        if let indexPath = sender as? IndexPath, let students = studentsInSearch,  let index = StudentsManager.instance.info.index(where: { (student) -> Bool in
            return student.id == students[indexPath.row].id
        }) {
            
            addEditStudentVC.selectedIndex = index
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  studentsInSearch?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        if let students = studentsInSearch{
            cell.textLabel?.text = students[indexPath.row].name + " " + students[indexPath.row].lastName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !onlyViewStudentFlag {
            //
        } else {
            performSegue(withIdentifier: "ShowAStudentSegue", sender: indexPath)
        }
    }




}
