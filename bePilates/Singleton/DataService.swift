//
//  DataService.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/16/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class DataService with a class property or Singleton, it also has 2 properties and 9 methods
 
 
The getStudents method gets students from the Snapshot.
 
 The getLogsRecord method gets Logs from the Snapshot.
 
 The getUserDefaults method gets the user information from the Snapshot.
 
 The fetchFromFireBase method gets the Snapshot data form the database.
 
 The saveLogToFireBase method saves Logs to the database.
 
 The saveUserDefaults method saves user information to the database.
 
 The removeLogFromFireBase method removes logs  from the database.
 
 The saveStudentToFireBase method saves Students to the database.
 
 The removeStudentFromFireBase method removes Students from the database.

 */
import Foundation
import Firebase

protocol DataServiceDelegate {
    func loadRecordsToUI()
}

class DataService {
    
    //MARK: - Variables
    
    static let instance = DataService()
    var delegate: DataServiceDelegate?
    let reference = Database.database().reference()
    
    //MARK: - Methods
    
    func getStudents (data: DataSnapshot ){
            for nestedData in data.children {
                guard let snapshotChildren = nestedData as? DataSnapshot else { break }
                if snapshotChildren.value != nil {
                    let rawJSON = (snapshotChildren.key,snapshotChildren.value! as AnyObject)
                    StudentsManager.instance.appendFromFirebase(rawJSON)
                }
            }
    }
    
    func getLogsRecord(data: DataSnapshot) {
            for nestedData in data.children {
                guard let snapshotChildren = nestedData as? DataSnapshot else { break }
                if snapshotChildren.value != nil {
                    let rawJSON = (snapshotChildren.key,snapshotChildren.value! as AnyObject)
                    InstructorRecords.instance.appendFromFirebase(rawJSON)
                }
            }
            self.delegate?.loadRecordsToUI()
    }
    
    func getUserDefaults(dataLogLatestID: DataSnapshot, dataStudentLatestID: DataSnapshot)  {
            if let latesLogId = dataLogLatestID.value as? Int, let latesStudentId = dataStudentLatestID.value as? Int  {
                InstructorRecords.instance.latestId = latesLogId
                StudentsManager.instance.latestId = latesStudentId
                print("User Defaults....")
                print(InstructorRecords.instance.latestId)
                print(StudentsManager.instance.latestId)
            } else {
                InstructorRecords.instance.latestId = 0
                 StudentsManager.instance.latestId = 0
            }
    }
    
    func fetchFromFireBase () {
     
        reference.child(PropertyKeys.USERDEFAULTS_PATH).observeSingleEvent(of: .value) { (userDefaultsData) in
            self.getUserDefaults(dataLogLatestID: userDefaultsData.childSnapshot(forPath: PropertyKeys.LOGID_KEY), dataStudentLatestID: userDefaultsData.childSnapshot(forPath:PropertyKeys.STUDENT_ID_KEY))
        }
        reference.child(PropertyKeys.RECORD_PATH).queryLimited(toLast: PropertyKeys.LogsToReturnFromFetchingFirebase).observeSingleEvent(of: DataEventType.value) { (latestLogData) in
            self.getLogsRecord(data: latestLogData)
        }
    
        reference.child(PropertyKeys.STUDENTS_PATH).observeSingleEvent(of: .value) { (otherData) in
            self.getStudents(data: otherData)
        }
    
  
    }
    
    func saveLogToFireBase (log: SessionLog){
            let logToSave: [String : Any] = log.convertLogToJSON()
            reference.child(PropertyKeys.RECORD_PATH).child("/\(log.id)").setValue(logToSave)
    }
    
    func saveUserDefaults (){
            let latestLogIDgiven: Int = InstructorRecords.instance.latestId
            let latestStudentIDgiven = StudentsManager.instance.latestId
            reference.child(PropertyKeys.USERDEFAULTS_PATH).setValue([PropertyKeys.LOGID_KEY : latestLogIDgiven, PropertyKeys.STUDENT_ID_KEY : latestStudentIDgiven])
    }
    
    func removeLogFromFireBase ( log: SessionLog){
            reference.child(PropertyKeys.RECORD_PATH).child("/\(log.id)").removeValue()
    }
    
    func saveStudentToFireBase (aStudent: Student){
            let studentToSave: [String : Any] = aStudent.convertStudentToJSON()
            reference.child(PropertyKeys.STUDENTS_PATH).child("/\(aStudent.id)").setValue(studentToSave)
    }

    func removeStudentFromFireBase ( student: Student){
            reference.child(PropertyKeys.STUDENTS_PATH).child("/\(student.id)").removeValue()
    }
    
    
}
