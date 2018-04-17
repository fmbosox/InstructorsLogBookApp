//
//  InstructorHomeViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 4/6/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class InstructorHomeViewController: UIViewController {

    
    @IBOutlet weak var viewStudentsButton: UIButton!
    {
        didSet {
            viewStudentsButton.layer.borderWidth = 0.17
            viewStudentsButton.layer.cornerRadius = 10.0
            viewStudentsButton.layer.shadowRadius  = 1.0
            viewStudentsButton.layer.shadowOpacity = 0.2
            viewStudentsButton.layer.shadowOffset = CGSize.init(width: 0, height: 2)
            viewStudentsButton.layer.shadowColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var viewReportButton: UIButton! {
        didSet {
            viewReportButton.layer.borderWidth = 0.17
            viewReportButton.layer.cornerRadius = 10.0
            viewReportButton.layer.shadowRadius  = 1.0
            viewReportButton.layer.shadowOpacity = 0.2
            viewReportButton.layer.shadowOffset = CGSize.init(width: 0, height: 2)
            viewReportButton.layer.shadowColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "View Students" {
            guard let studentsVC = segue.destination as? StudentsSelectionViewController else { return }
                studentsVC.navigationItem.leftBarButtonItems?.removeAll()
                studentsVC.onlyViewFlag = true
                studentsVC.navigationItem.title = "Your Students"
        } else if segue.identifier == "Show Report" {
            let startDate = Date(timeInterval: (-3600*24*30.43), since: Date())
            let endDate = Date()
            let aPDF = ReportMaker(instructorName: "Linda Valdez", email: "linda.trece@hotmail.com", startDate: startDate, endDate: endDate).makePDF()
            let PDFViewerViewController = segue.destination as! PDFViewerViewController
            PDFViewerViewController.pdfDocument = aPDF
        }
    }


}
