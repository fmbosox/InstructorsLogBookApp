//
//  InstrcutorRecords.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class InstructorRecords conforms to the Manager protocol and has class property or Singleton, it also has 2 properties and 2 methods. It has the main purpuse of handiling the SessionLog data generetad by the user.

The singleton will have the capacity to store objects of SessionLog.
 So it has an array named info to store the data, and latestId to keep track of the latest ID assigned.
 
 The saveNewLog method its called when the users wants to ceate a brand new log and calls DataService.
 
 The purpose of the orderByNewest method is to re arrange the array based on the date (descending)

*/

import Foundation

class InstructorRecords {
    
    static let instance = InstructorRecords ()
    var info = [SessionLog]()
    var latestId = Int()

    //MARK: Methods
    
    func saveNewLog( type: SessionType, date: Date, studentsInSession: [Student]) {
            InstructorRecords.instance.latestId += 1
        //let dateComponents = DateComponents(minute: 30)
      //  trying to manipulate date.
            let newID = InstructorRecords.instance.latestId
            let newLog = SessionLog(id: newID, type: type, date: date, studentsInSession: studentsInSession)
            InstructorRecords.instance.info.append(newLog)
            DataService.instance.saveLogToFireBase(log: newLog)
            DataService.instance.saveUserDefaults()
    }
    
    func orderByNewest(){
            InstructorRecords.instance.info = InstructorRecords.instance.info.sorted(by: { (logOne, logTwo) -> Bool in
                return logOne.date > logTwo.date
            })
    }

}

extension InstructorRecords: Manager {
    
    func appendFromFirebase(_ firebaseRawJSON: (ID: String, rawJSON: AnyObject) )  {
        guard let JSON = firebaseRawJSON.rawJSON as? Dictionary<String, AnyObject> else { return }
        let log = SessionLog(firebaseRawJSON.ID, JSON )
        InstructorRecords.instance.info.append(log!)
    }
    
    func removeAt(_ index: Int){
        DataService.instance.removeLogFromFireBase(log: InstructorRecords.instance.info[index])
        InstructorRecords.instance.info.remove(at: index)
    }
    
    func saveEdited(_ index: Int)    {
        let anExistingLogToSave = InstructorRecords.instance.info[index]
        DataService.instance.saveLogToFireBase(log:anExistingLogToSave)
    }

}
