//
//  SessionLog.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/* Defined two types: SessionType to limit and make the code safer to use, then we have a struct SessionLog with 5 properties and 5 computed properties to protect our data of directly modifications.
 
 An object of SessionLog will hold all the information from a  particular (Pilates, Yoga, Crossfit,etc) session/class
 
 */
import Foundation

enum SessionType {
    case MAT
    case GAP
    case CANCELLED
}


struct SessionLog {
    private let  _id: Int
    private var _type: SessionType!
    private var _date: Date
    private var _studentsInSession : [Student]
    
//computed properties section
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
            return _studentsInSession
        } set {
            _studentsInSession = newValue
        }
    }
    
    
// methods sections
    
    init(id:Int, type: SessionType, date: Date, studentsInSession: [Student]) {
        _id = id
        _type = type
        _date = date
         _studentsInSession = studentsInSession
    }
    
    
    
}
