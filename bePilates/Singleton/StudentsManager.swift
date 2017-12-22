//
//  StudentsManager.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/11/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class StudentsManager conforms to the Manager protocol and has  a class property or Singleton, it also has 2 properties and a method.
 
 The singleton will have the capacity to store objects of Student.
 So it has an array named info to store the data, and latestId to keep track of the latest ID assigned.
 
 The saveNewStudent method it called when the users wants to ceate a new student and calls DataService.
 
 */

import Foundation

class StudentsManager {
    
    static let instance = StudentsManager ()
    var info = [Student]()
    var latestId = Int()

    func saveNewStudent( name: String, lastName: String, email: String, observation: String?) {
            StudentsManager.instance.latestId += 1
            let newID = StudentsManager.instance.latestId
            let newStudent = Student(id: newID, name: name, lastName: lastName, email: email, observation: observation)
            StudentsManager.instance.info.append(newStudent)
            DataService.instance.saveStudentToFireBase(aStudent: newStudent)
            DataService.instance.saveUserDefaults()
    }
    
}

extension StudentsManager: Manager {
    
    func appendFromFirebase(_ firebaseRawJSON: (ID: String, rawJSON: AnyObject) )  {
        guard let JSON = firebaseRawJSON.rawJSON as? Dictionary<String, AnyObject> else { return }
        let student = Student(firebaseRawJSON.ID, JSON )
        StudentsManager.instance.info.append(student!)
    }
    
    func removeAt(_ index: Int){
        DataService.instance.removeStudentFromFireBase(student: StudentsManager.instance.info[index])
        StudentsManager.instance.info.remove(at: index)
    }
    
    func saveEdited(_ index: Int) {
        let anExistingStudentToSave = StudentsManager.instance.info[index]
        DataService.instance.saveStudentToFireBase(aStudent: anExistingStudentToSave)
    }
}
