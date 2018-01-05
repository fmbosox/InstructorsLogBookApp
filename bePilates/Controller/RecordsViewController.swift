//
//  RecordsViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    
    //MARK: Variables
    
    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var logForSelectedRow: SessionLog?
    var tableViewCellAnimationType: AnimationType = .none
    
    //MARK: Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.delegate = self
        tableViewCellAnimationType = .scrolling
        instructorNameLabel.text = "Linda Valdez"
        InstructorRecords.instance.orderByNewest()
    }
    
    @IBAction func addLogButtonPressed(_ sender: UIButton) {
        aButtonAnimation(animate: sender )
    }
    
    // MARK:  Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditLogSegue" else { return }
        let AddEditLogViewController = segue.destination as! AddEditLogViewController
        let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
        let selectedIndex = indexPathForSelectedRow.row
        logForSelectedRow = InstructorRecords.instance.info[selectedIndex]
        AddEditLogViewController.selectedIndex =  selectedIndex
    }
    
    @IBAction func unwindToRecordsViewController (segue: UIStoryboardSegue ){
          tableViewCellAnimationType = .goingBack
         InstructorRecords.instance.orderByNewest()
         tableView.reloadData()
         scrollToCell()
    }

}

    //MARK: table view config

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstructorRecords.instance.info.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        if  (tableViewCellAnimationType == .goingBack  && (logForSelectedRow?.id == InstructorRecords.instance.info[indexPath.row].id ||  InstructorRecords.instance.info[indexPath.row].id == InstructorRecords.instance.latestId )) {
                viewAnimation(for: tableViewCellAnimationType, cell: cell)
        } else if tableViewCellAnimationType == .goingBack {
            viewAnimation(for: .none, cell: cell)
        } else {
            viewAnimation(for: tableViewCellAnimationType, cell: cell)
        }
        cell.configureCell(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let cell = tableView.cellForRow(at: indexPath) as! LogCell
        cell.selectedCellAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            InstructorRecords.instance.removeAt(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            InstructorRecords.instance.orderByNewest()
            tableView.reloadData()
        }
    }
    
}

    //MARK:  DataServiceDelegate protocol

extension RecordsViewController: DataServiceDelegate {
    
    func loadRecordsToUI() {
        InstructorRecords.instance.orderByNewest()
        tableView.reloadData()
    }
    
}

    //MARK: Animation logic

extension RecordsViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableViewCellAnimationType = .scrolling
    }
    
    enum AnimationType {
        case goingBack
        case none
        case scrolling
    }
    
    func aButtonAnimation (animate button: UIButton) {
        let animation = CASpringAnimation.init(keyPath: "transform.scale")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.initialVelocity = 0.9
        animation.damping = 1
        animation.fromValue = 1.0
        animation.toValue = 0.65
        button.layer.add(animation, forKey: nil)
    }
    
    func viewAnimation (for animationType: AnimationType,   cell: LogCell) {
        switch animationType {
        case .goingBack:
                                    cell.goingBackAnimation()
        case .none: break
        case .scrolling: cell.goingBackAnimation()
        }
        
    }

    func scrollToCell (){
        if let aLog = logForSelectedRow {
            let row = InstructorRecords.instance.info.index(where: { (log) -> Bool in
                log.id == aLog.id
            })
            tableView.scrollToRow(at: IndexPath.init(row: row!, section: 0), at: .middle, animated: true)
        } else {
            let row = InstructorRecords.instance.info.index(where: { (log) -> Bool in
                log.id == InstructorRecords.instance.latestId
            })
            tableView.scrollToRow(at: IndexPath.init(row: row!, section: 0), at: .middle, animated: true)
        }
        logForSelectedRow = nil
    }
    
}




