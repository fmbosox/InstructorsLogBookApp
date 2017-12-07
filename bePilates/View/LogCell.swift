//
//  LogCell.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var studentsLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var typeLabelContainerView: UIView!
    
    let dateFormatter = DateFormatter()
    let hourFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = PropertyKeys.DATE_FORMAT
        hourFormatter.dateFormat = PropertyKeys.HOUR_FORMAT
        drawCell()
        
    }
    
    func drawCell() {
        infoContainerView.layer.borderWidth = 0.87
        infoContainerView.layer.borderColor = UIColor(red: 97/255, green: 161/255, blue: 232/255, alpha: 1.0).cgColor
        infoContainerView.layer.masksToBounds = false
        infoContainerView.layer.cornerRadius = 10.0
        infoContainerView.layer.shadowRadius  = 5.0
        infoContainerView.layer.shadowOpacity = 0.8
        infoContainerView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        infoContainerView.layer.shadowColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        
        
           typeLabelContainerView.layer.cornerRadius = 31.0
        
    }
    
    
  func  configureCell (_ index: Int) {
    
    
    
    let currentLog = InstructorRecords.instance.info[index]
    
    dateLabel.text = dateFormatter.string(from: currentLog.date)
    
    switch currentLog.type {
        case .MAT: typeLabel.text = PropertyKeys.MAT_STRING  
        case .GAP: typeLabel.text = PropertyKeys.GAP_STRING
        case .CANCELLED : typeLabel.text = PropertyKeys.CANCELLED_STRING
        default: typeLabel.text = ""
    }
    
    hourLabel.text = hourFormatter.string(from: currentLog.date)
    
    studentsLabel.text = currentLog.studentsInSession.count < 3 ? currentLog.studentsInSession.flatMap({ (student) -> String? in
        return student.name
    }).joined(separator: ", ") + "."  :     currentLog.studentsInSession[0].name + ", " + currentLog.studentsInSession[1].name + " & \(currentLog.studentsInSession.count-2) more."
    }
}
