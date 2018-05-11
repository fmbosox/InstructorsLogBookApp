//
//  AddStudentToSessionCollectionViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 5/8/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

private let addStudentReuseIdentifier = "Student Cell"

var studentsInSession: [Student] = []

class AddStudentToSessionCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + studentsInSession.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addStudentReuseIdentifier, for: indexPath)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            print("present the search controller to add student")
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }


        var searchController: UISearchController!
        var searchResultsVC: StudentSearchResultsTableViewController?
    
        func setupSearchController() {
            // Settign up the search Controller.
            searchResultsVC = (storyboard?.instantiateViewController(withIdentifier: "Add Students Search") as? StudentSearchResultsTableViewController)
            guard let searchVC = searchResultsVC else { return }
            searchController = UISearchController(searchResultsController: searchVC)
            searchVC.onlyViewStudentFlag = false
            
            // Setting the search bar
            if let searchBar = searchController?.searchBar {
                searchController?.hidesNavigationBarDuringPresentation = true
                searchBar.placeholder = "Search for a Student"
                self.collectionView?.addSubview(searchBar)

        
                
                
                searchBar.delegate = self
            }
            
            
            
            // Signing up as an updater
            searchController?.searchResultsUpdater = self
            
            
            
        }
        

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}




extension AddStudentToSessionCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate , UISearchControllerDelegate{
    
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

