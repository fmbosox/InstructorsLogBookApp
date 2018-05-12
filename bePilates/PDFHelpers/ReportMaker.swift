//
//  ReportMaker.swift
//  bePilates
//
//  Created by Felipe Montoya on 1/9/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import PDFKit

class ReportMaker: NSObject {
    
    let pathTo_baseHTML = Bundle.main.path(forResource: "base", ofType: "html")
    let pathTo_descriptionTableHTML = Bundle.main.path(forResource: "descriptionTable", ofType: "html")
    let pathTo_aRowHTML = Bundle.main.path(forResource: "aRow", ofType: "html")
    let pathTo_lastRowHTML = Bundle.main.path(forResource: "lastRow", ofType: "html")
    
    private var _instructorName: String!
    private var _instructorEmail: String!
    private var _startDateString: String!
    private var _endDateString: String!
    private var _dictionaryWithLogs: [String:[SessionLog]]!
    
    
    override init() {
        super.init()
    }
    
    convenience init(instructorName: String, email: String, startDate: Date, endDate: Date) {
       self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PropertyKeys.DATE_FORMAT
        self._instructorName = instructorName
        self._instructorEmail = email
        self._startDateString = dateFormatter.string(from: startDate)
        self._endDateString = dateFormatter.string(from: endDate)
        self._dictionaryWithLogs = InstructorRecords.instance.filterRecordsByTypeFromLast(DateInterval(start: startDate, end: endDate))
    }
    
    func renderHTML() -> String! {
        do{
            var baseHTMLContent = try String.init(contentsOfFile: pathTo_baseHTML!)
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#MONTH#", with: "Monthly Report" )
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#START_DATE#", with: _startDateString)
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#END_DATE#", with: _endDateString)
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#INSTRUCTOR_NAME#", with: _instructorName)
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#INSTRUCTOR_EMAIL#", with: _instructorEmail)
            
            var allDescriptionTables = ""
            var total = 0
            for aKey in _dictionaryWithLogs.keys {
                    var descriptionTableHTMLContent = try String.init(contentsOfFile: pathTo_descriptionTableHTML!)
                    let currentLogs = _dictionaryWithLogs[aKey]!
                    if !currentLogs.isEmpty {
                            descriptionTableHTMLContent = descriptionTableHTMLContent.replacingOccurrences(of:  "#SESSION_TYPE#", with: aKey)
                            var rowsInSection = ""
                            var subTotal = 0
                            for index in 0..<currentLogs.count {
                                    var rowHTMLContent: String!
                                    if index != currentLogs.count - 1 {
                                        rowHTMLContent = try String(contentsOfFile: pathTo_aRowHTML!)
                                    }
                                    else {
                                        rowHTMLContent = try String(contentsOfFile: pathTo_lastRowHTML!)
                                    }
                                    var sessionDescription: String {
                                        var description: String
                                        let dateFormater = DateFormatter()
                                        let timeFormater = DateFormatter()
                                        dateFormater.dateStyle = .short
                                        timeFormater.timeStyle = .short
                                        description = dateFormater.string(from: currentLogs[index].date) + " @ " + timeFormater.string(from: currentLogs[index].date)
                            
                                        if  currentLogs[index].studentsInSession.first!.name != "No Aplica" {
                                            description  +=  "  **" + currentLogs[index].studentsInSession.compactMap({ (aStudent) -> String? in
                                                aStudent.name
                                            }).joined(separator: ", ")
                                        }
                                        
                                        switch currentLogs[index].type as SessionType {
                                        case .MAT, . GAP, .AERO: break
                                        case .CANCELLED_GAP, .CANCELLED_MAT, .CANCELLED_AERO:  description = "<em>\(description)</em> -- CANCELLED"
                                        }
                                        
                                        return description
                                    }
                                    var sessionPrice: String {
                                        subTotal += currentLogs[index].type.price
                                        return String(currentLogs[index].type.price)
                                    }
                                    rowHTMLContent = rowHTMLContent.replacingOccurrences(of: "#SESSION_DESCRIPTION#", with: sessionDescription)
                                    rowHTMLContent = rowHTMLContent.replacingOccurrences(of: "#SESSION_PRICE#", with: sessionPrice)
                                    rowsInSection += rowHTMLContent
                        }
                        descriptionTableHTMLContent = descriptionTableHTMLContent.replacingOccurrences(of:  "#TABLE_ROWS#", with: rowsInSection)
                        descriptionTableHTMLContent = descriptionTableHTMLContent.replacingOccurrences(of:  "#SUBTOTAL#", with: String(subTotal))// calcular subtotal
                        allDescriptionTables += descriptionTableHTMLContent
                        total += subTotal
                }// If the array of the corresponding key is empty do nothing
            }
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#DESCRIPTIONS_TABLES#", with: allDescriptionTables)
            baseHTMLContent  = baseHTMLContent.replacingOccurrences(of: "#TOTAL#", with: String(total)) //calcular total
            
       //     print(baseHTMLContent)
            
            return baseHTMLContent // a Modified version of baseHTML is ready
            
            
        } catch {
            print("Opps, something went wrong... Unable to open HTML Files")
        }
        return nil
    }
    
    
    
    func makePDF () -> PDFDocument!{
        let pageRenderer = PageRenderer()
        let data = NSMutableData()
        let HTMLPrintFormater = UIMarkupTextPrintFormatter.init(markupText: renderHTML())
       pageRenderer.addPrintFormatter(HTMLPrintFormater, startingAtPageAt: 0)
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for index in 0..<pageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            pageRenderer.drawPage(at: index, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return PDFDocument(data: data as Data)
    }
    
    
}


