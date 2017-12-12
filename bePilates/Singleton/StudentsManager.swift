//
//  StudentsManager.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/11/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*  Defined a class StudentsManager with a class property or Singleton, it also has 2 properties and a method
 
 The singleton will have the capacity to store objects of Student.
 So it has an array named info to store the data, and latestId to keep track of the latest ID assigned.
 
 The saveNewStudent method it called when the users wants to ceate a new student
 
 */

import Foundation

class StudentsManager {
    
    static let instance = StudentsManager ()
    
    var info = [Student]()
    var latestId = 0
    
    // methods sections
    func saveNewStudent( name: String, lastName: String, email: String, observation: String?) {
        StudentsManager.instance.latestId += 1
        let newID = StudentsManager.instance.latestId
        let newStudent = Student(id: newID, name: name, lastName: lastName, email: email, observation: observation)
        StudentsManager.instance.info.append(newStudent)
    }

}
