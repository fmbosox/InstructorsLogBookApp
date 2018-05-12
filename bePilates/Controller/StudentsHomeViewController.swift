//
//  StudentsHomeViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 4/18/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class StudentsHomeViewController: UIViewController {

    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    
    
    var searchController: UISearchController!
    var searchResultsVC: StudentSearchResultsTableViewController?
    func setupSearchController() {
        // Settign up the search Controller.
            searchResultsVC = (storyboard?.instantiateViewController(withIdentifier: "Search Students") as? StudentSearchResultsTableViewController)
        guard let searchVC = searchResultsVC else { return }
            searchController = UISearchController(searchResultsController: searchVC)
            searchVC.onlyViewStudentFlag = true
        
            // Setting the search bar in the proper space
        if let searchBar = searchController?.searchBar {
            searchController?.hidesNavigationBarDuringPresentation = true
            searchBar.placeholder = "Search for a Student"
            
            let containter = self.view.subviews.first?.subviews.first { $0.tag == 2 }
            containter?.addSubview(searchBar)
            containter?.subviews.first?.frame = containter!.frame
            searchBar.delegate = self
        }
    
        
        
            // Signing up as an updater
            searchController?.searchResultsUpdater = self
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberOfStudentsLabel.text = StudentsManager.instance.info.count.description
        setupSearchController()
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
}


extension StudentsHomeViewController: UISearchResultsUpdating, UISearchBarDelegate , UISearchControllerDelegate{

    func updateSearchResults(for searchController: UISearchController) {
        
        if (searchController.searchBar.text?.first == " ") && searchController.searchBar.text?.count != nil && searchController.searchBar.text!.count > 1 {
                _ = searchController.searchBar.text?.removeFirst()
        }
//             else  if searchController.searchBar.text == "" {
//                       searchController.searchBar.text? = " "
//            }

    
            if let text = searchController.searchBar.text, text != " " {
                print("Update! -- \(text)")
                searchResultsVC?.studentsInSearch = StudentsManager.instance.info.filter({ (aStudent) -> Bool in
                    String(aStudent.name).contains(text) || String(aStudent.lastName).contains(text)
                })

            } else {
                searchResultsVC?.studentsInSearch = StudentsManager.instance.info
            }
        
            searchResultsVC?.tableView.reloadData()
        
    }
    
    
    func presentSearchController(_ searchController: UISearchController) {
        //
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = " "
    }

    
}
