//
//  InstrcutorRecords.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class InstructorRecords with an class property or Singleton, it has a property and a method.

The singleton will have the capacity to store objects of SessionLog.

*/

import Foundation


class InstructorRecords {
    
    static let instance = InstructorRecords ()
    
    var info = [SessionLog]()
    var latestId = 0

// methods sections
    func saveNewLog( type: SessionType, date: Date, studentsInSession: [Student]) {
        
            InstructorRecords.instance.latestId += 1
            let newID = InstructorRecords.instance.latestId
            let newLog = SessionLog(id: newID, type: type, date: date, studentsInSession: studentsInSession)
            InstructorRecords.instance.info.append(newLog)
        
    }
    
    func orderByNewest(){
        InstructorRecords.instance.info = InstructorRecords.instance.info.sorted(by: { (logOne, logTwo) -> Bool in
           return logOne.date > logTwo.date
        })
    }


}
