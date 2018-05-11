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
    
    
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var addLogButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var logForSelectedRow: SessionLog?
    var tableViewCellAnimationType: AnimationType = .none
    
    
    func toggleSearchBar () {
        
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 12.42,
                                                   delay: 0.0,
                                                   options: .curveLinear,
                                                   animations: { if self.searchBar.isHidden {
                                                    self.searchBar.frame.size.height = 0.0
                                                    
                                                    }  },
                                                   completion: nil)
        searchBar.isHidden = !searchBar.isHidden
        addLogButton.isHidden = !searchBar.isHidden
        
    }
    
    @objc func swipeAndShowSearchBar(gesture: UIGestureRecognizer){
        
        guard let gesture = gesture as? UIPanGestureRecognizer else { return }
        
        switch gesture.state {
        case .began:
            if gesture.translation(in: self.view).y > 0.5 {
                toggleSearchBar()
            }
            if gesture.translation(in: self.view).y < -0.5 {
                toggleSearchBar()
            }
        default:
            return
        }
    }
    
    
   
    
    //MARK: Initial Setup
    
    let searchBar: UISearchBar = UISearchBar(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
    
    @IBOutlet weak var backGroundView: UIView! {
        didSet{
            //Search functionality
            let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(swipeAndShowSearchBar(gesture:)))
            swipeDown.maximumNumberOfTouches = 1
            backGroundView.addGestureRecognizer(swipeDown)
        }
    }

    
    
    func setSearchBar () {
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search for a Class"
        searchBar.scopeButtonTitles = ["By Students", "MAT","GAP","AERO"]
        searchBar.showsScopeBar = true
        searchBar.selectedScopeButtonIndex = 0
        searchBar.frame.size.width = self.view.frame.width
        searchBar.frame.size.height = self.view.frame.height * 0.16
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.delegate = self
        tableViewCellAnimationType = .scrolling
        navigationItem.title = "Records"
        InstructorRecords.instance.orderByNewest()
        setSearchBar()
        
        backGroundView.addSubview(searchBar)
        searchBar.isHidden = true
        searchBar.delegate = self
    
    }
    
    @IBAction func addLogButtonPressed(_ sender: UIButton) {
        aButtonAnimation(animate: sender )
    }
    

    
    // MARK:  Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit Log Segue" {
        let AddEditLogViewController = segue.destination as! EditLogViewController
        let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
        let selectedIndex = indexPathForSelectedRow.row
        logForSelectedRow = InstructorRecords.instance.info[selectedIndex]
        AddEditLogViewController.selectedIndex =  selectedIndex
        } 
    }
    
    @IBAction func unwindToRecordsViewController (segue: UIStoryboardSegue ){
          tableViewCellAnimationType = .goingBack
         InstructorRecords.instance.orderByNewest()
         tableView.reloadData()
         scrollToCell()
    }
    
    
    
    @IBAction func searchButttonTapped (sender: Any?) {
        if  searchBar.isHidden {
            toggleSearchBar()
        } else {
            searchBar.text = nil
        }
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


extension RecordsViewController: UISearchBarDelegate {
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("SearchBar text begin editign")
      //  tableView.isHidden = true
        //Put a search image on UI!!
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("SearchBar text end editign")
//        if InstructorRecords.instance.unfilteredInfo?.count != InstructorRecords.instance.info.count {
//            InstructorRecords.instance.info = InstructorRecords.instance.unfilteredInfo!
//            tableView.reloadData()
//        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.selectedScopeButtonIndex == 1 || searchBar.selectedScopeButtonIndex == 2 || searchBar.selectedScopeButtonIndex == 3 {
            return false
        }else {
            return true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button tapped")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty, let info = InstructorRecords.instance.unfilteredInfo{
            InstructorRecords.instance.info = info
        } else {
            print("searchBar text did change")
            if searchBar.selectedScopeButtonIndex == 0 {
                InstructorRecords.instance.filterByStudentsInClass(studentName: searchBar.text!)
            }
        }
        showSearchResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped")
        searchBar.resignFirstResponder()
//        if searchBar.selectedScopeButtonIndex == 0 {
//            if searchBar.text != "" {
//                InstructorRecords.instance.filterByStudentsInClass(studentName: searchBar.text!)
//            }
//            showSearchResults()
//        }
        
    }
    
    
    func showSearchResults () {
        tableView.reloadData()
        tableView.isHidden = false
       // searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("Scope  did change")
        
        if selectedScope == 1 {
              searchBar.text = ""
            InstructorRecords.instance.filterByType(type: SessionType.MAT)
            searchBar.placeholder = "\(InstructorRecords.instance.info.count) - MAT Sessions found"
            showSearchResults ()
            searchBar.resignFirstResponder()
        }else if selectedScope == 2 {
              searchBar.text = ""
             InstructorRecords.instance.filterByType(type: SessionType.GAP)
            searchBar.placeholder = "\(InstructorRecords.instance.info.count) - GAP Sessions found"
            showSearchResults ()
             searchBar.resignFirstResponder()
        } else if selectedScope == 3 {
              searchBar.text = ""
             InstructorRecords.instance.filterByType(type: SessionType.AERO)
            searchBar.placeholder = "\(InstructorRecords.instance.info.count) - AERO Sessions found"
            showSearchResults ()
             searchBar.resignFirstResponder()
        } else {
            searchBar.placeholder = "Search for a Student in a Class"
            searchBar.text = ""
            InstructorRecords.instance.info = InstructorRecords.instance.unfilteredInfo!
            showSearchResults()
        }
    }
    
    
}




