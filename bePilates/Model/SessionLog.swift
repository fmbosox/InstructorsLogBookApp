//
//  SessionLog.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/* Defined two types: SessionType to limit and make the code safer to use, then we have a struct SessionLog with 4 properties and 4 computed properties to protect our data from directly modifications. It has 2 initializers, one of them can return nil. It has a method.

 The convertLogToJSON method converts the session Log into a Dictonary, useful to save it to the database.
 
 An object of SessionLog will hold all the information from a  particular (Pilates, Yoga, Crossfit,etc) session/class
 
 */
import Foundation

enum SessionType: String {
    case MAT
    case GAP
    case AERO
    case CANCELLED_MAT  = "XMAT"
    case CANCELLED_GAP = "XGAP"
    case CANCELLED_AERO = "XAERO"
    
    var price: Int {
        switch self {
            case .MAT:  return PropertyKeys.MAT_PRICE
            case .GAP: return PropertyKeys.GAP_PRICE
            case .CANCELLED_MAT: return PropertyKeys.CANCELLED_MAT_PRICE
            case .CANCELLED_GAP: return PropertyKeys.CANCELLED_GAP_PRICE
            case .AERO: return PropertyKeys.AERO_PRICE
            case .CANCELLED_AERO: return PropertyKeys.CANCELLED_AERO_PRICE
        }
    }
    
}

struct SessionLog {
    private let  _id: Int
    private var _type: SessionType!
    private var _date: Date
    private var _studentsInSession : [Student]?
    
    //MARK: - Computed properties
    
    var  id: Int {
        return _id
    }
    
    var  type: SessionType!  {
        get {
            return _type
        } set {
            _type = newValue
        }
    }
    
    var date: Date   {
        get {
            return _date
        } set {
            _date = newValue
        }
    }
    
    var studentsInSession: [Student]  {
        get {
            if let unwrappedStudentsInSession = _studentsInSession {
                return unwrappedStudentsInSession
            } else {
                return [Student.init(id: 0, name: "No Aplica", lastName: "No Aplica", email: "No Aplica", observation: nil)]
            }
            
        } set {
            if !newValue.isEmpty {
                _studentsInSession = newValue
            }else {
                _studentsInSession = nil
            }
        }
    }
    
    
    //MARK: -Methods
    
    init(id:Int, type: SessionType, date: Date, studentsInSession: [Student]) {
            _id = id
            _type = type
            _date = date
        _studentsInSession = !studentsInSession.isEmpty ? studentsInSession : nil
    }

    init?(_ ID: String ,_ logData: Dictionary<String, AnyObject>)  {
        guard let date = logData["date"] as? String, let type = logData["type"] as? String else { return nil }
            _id = Int(ID)!
            _type = SessionType.init(rawValue: type)
            if  let studentsInSessionIDs = logData["StudentsIds"] as? [Int] {
                var studentsInSession: [Student] = []
                for aStudentID  in studentsInSessionIDs {
                    let index = StudentsManager.instance.info.index(where: { (student) -> Bool in
                        student.id == aStudentID
                    })
                    if let unwrappedIndex = index  {
                        studentsInSession.append(StudentsManager.instance.info[unwrappedIndex])
                        _studentsInSession = studentsInSession
                    }
                }
            } else {
                _studentsInSession = nil
            }
            PropertyKeys.dateFormatter.dateStyle = .full
            PropertyKeys.dateFormatter.timeStyle = .full
            _date = PropertyKeys.dateFormatter.date(from: date)!
    }
 
    func convertLogToJSON () -> [String : Any]{
            var aJSON = [String : Any]()
            PropertyKeys.dateFormatter.dateStyle = .full
            PropertyKeys.dateFormatter.timeStyle = .full
            aJSON["date"] = PropertyKeys.dateFormatter.string(from: self.date)
            aJSON["type"] = self._type.rawValue
            aJSON["StudentsIds"] = _studentsInSession != nil  ? self._studentsInSession!.map({ (student) -> Int in
                return student.id
            }) : nil
            return aJSON
    }
    
}
