//
//  RecordsViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Simulate.instance.beginSimulation()
        InstructorRecords.instance.orderByNewest()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditLogSegue" else { return }
        let AddEditLogViewController = segue.destination as! AddEditLogViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedIndex = indexPath.row
        AddEditLogViewController.selectedIndex =  selectedIndex
    }
    
    @IBAction func unwindToRecordsViewController (segue: UIStoryboardSegue ){
         InstructorRecords.instance.orderByNewest()
        tableView.reloadData()
          print(InstructorRecords.instance.latestId)
    }

}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstructorRecords.instance.info.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        cell.configureCell(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            InstructorRecords.instance.info.remove(at: indexPath.row)
            InstructorRecords.instance.orderByNewest()
            tableView.reloadData()
        }
    }
    
}




