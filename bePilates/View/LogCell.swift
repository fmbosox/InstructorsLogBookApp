//
//  LogCell.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class LogCell to set the desired View of the Table View Cell it has 2 methods.
 
 drawCell() is used to draw the cell.
 configureCell() is used to set the correct text in the cell's labels.
 selectedCellAnimation() is used to animate a selection of a cell.
 goingBackAnimation() is called when going back to the main view. Adds an special effects to the cells.
 
 */

import UIKit

class LogCell: UITableViewCell {

    //Mark: Variables
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var studentsLabel: UILabel!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var typeLabelContainerView: UIView!
    
    let dateFormatter: DateFormatter = DateFormatter()
    let hourFormatter: DateFormatter = DateFormatter()
 
    //Mark: Initial drawing
    
    func drawCell() {

        infoContainerView.layer.borderWidth = 0.97
        infoContainerView.layer.masksToBounds = false
        infoContainerView.layer.cornerRadius = 10.0
        infoContainerView.layer.shadowRadius  = 5.0
        infoContainerView.layer.shadowOpacity = 0.8
        infoContainerView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        infoContainerView.layer.shadowColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        typeLabelContainerView.layer.cornerRadius = 31.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = PropertyKeys.DATE_FORMAT
        hourFormatter.dateFormat = PropertyKeys.HOUR_FORMAT
        drawCell()
    }
    
  func  configureCell (_ index: Int) {
        let currentLog = InstructorRecords.instance.info[index]
        dateLabel.text = dateFormatter.string(from: currentLog.date)
        typeLabel.text = currentLog.type.rawValue
        if currentLog.type == SessionType.CANCELLED_GAP || currentLog.type == SessionType.CANCELLED_MAT {
            infoContainerView.layer.borderColor = UIColor(red: 168/255, green: 78/255, blue: 71/255, alpha: 1.0).cgColor
            typeLabelContainerView.layer.backgroundColor = UIColor(red: 168/255, green: 78/255, blue: 71/255, alpha: 1.0).cgColor
            hourLabel.textColor = UIColor(red: 168/255, green: 78/255, blue: 71/255, alpha: 1.0)
            studentsLabel.textColor =  UIColor(red: 168/255, green: 78/255, blue: 71/255, alpha: 1.0)
        } else {
            infoContainerView.layer.borderColor = UIColor(red: 97/255, green: 161/255, blue: 232/255, alpha: 1.0).cgColor
            typeLabelContainerView.layer.backgroundColor = UIColor(red: 50/255, green: 100/255, blue: 155/255, alpha: 1.0).cgColor
            hourLabel.textColor = UIColor(red: 50/255, green: 100/255, blue: 155/255, alpha: 1.0)
            studentsLabel.textColor =  UIColor(red: 50/255, green: 100/255, blue: 155/255, alpha: 1.0)
        }
        hourLabel.text = hourFormatter.string(from: currentLog.date)
         if currentLog.type == SessionType.CANCELLED_GAP || currentLog.type == SessionType.CANCELLED_MAT {
                       studentsLabel.text =  "CANCELLED"
         } else {
            studentsLabel.text = currentLog.studentsInSession.count < 3 ? currentLog.studentsInSession.flatMap({ (student) -> String? in
                return student.name
            }).joined(separator: ", ") + "."  :     currentLog.studentsInSession[0].name + ", " + currentLog.studentsInSession[1].name + " & \(currentLog.studentsInSession.count-2) more."
        }
    }
    
    //Mark: Animation
    
    func selectedCellAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.infoContainerView.layer.borderWidth = 3.97
            self.infoContainerView.layer.opacity = 0.99
        }) { (_) in
            UIView.animate(withDuration: 0.1) {
                self.infoContainerView.layer.borderWidth = 0.97
               self.infoContainerView.layer.opacity = 1.0
            }
        }
    }

    func goingBackAnimation() {
        UIView.animate(withDuration: Double(0.2), delay: Double(0.04), options: .curveEaseOut, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1.14, y: 1.14 )
            let comboTransform = scaleTransform
            self.infoContainerView.transform = comboTransform
            //self.infoContainerView.layer.setAffineTransform(comboTransform)
        }) { (_) in
            UIView.animate(withDuration: Double(0.24)) {
                let scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0 )
                // self.infoContainerView.layer.setAffineTransform(scaleTransform)
                self.infoContainerView.transform = scaleTransform
            }
        }
    }
    
}


