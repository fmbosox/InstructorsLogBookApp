//
//  InstrcutorRecords.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class InstructorRecords with a class property or Singleton, it also has 2 properties and two methods. It has the main purpuse of handiling the SessionLog data generetad by the user.

The singleton will have the capacity to store objects of SessionLog.
 So it has an array named info to store the data, and latestId to keep track of the latest ID assigned.
 
 The saveNewLog method it called when the users wants to ceate a brand new log.
 
 The purpose of the orderByNewest method is to re arrange the array based on the date (descending)

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
