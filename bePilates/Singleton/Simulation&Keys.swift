//
//  Simulation&Keys.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

/*  Defined a struct PropertyKeys  to hold keys to use across the project.
    Defined a Class Simulate with a class property o Singleton, 2 property and a method.
 
 loadSimStudents() will set predefined students
 beginSimulation() will set predefined values.
 
 An object of Simulate will help in the simulation enviroment.
 
 */

import Foundation

struct PropertyKeys {
    // Add keys that you want to use acrros your project
    
    static let DATE_FORMAT = "EEE, dd-MMM"
    static let HOUR_FORMAT = "h:mm a"
    static let STUDENTS_PATH = "/students"
    static let RECORD_PATH = "/record"
    static let USERDEFAULTS_PATH =  "/userDefaults"
    static let LOGID_PATH = "/userDefaults/logLatestID"
    static let STUDENT_ID_PATH = "/userDefaults/studentLatestID"
    static let LOGID_KEY = "logLatestID"
    static let STUDENT_ID_KEY = "studentLatestID"
    
    static let dateFormatter: DateFormatter = DateFormatter()
    static let hourFormatter:DateFormatter = DateFormatter()
    
}

class Simulate {
    
    static let instance = Simulate()
    
    func beginSimulation () {
        loadSimStudents()
        InstructorRecords.instance.latestId = 3
        InstructorRecords.instance.info = [SessionLog(id: 1, type: SessionType.MAT ,date: Date(timeIntervalSinceNow: -445000.00), studentsInSession: StudentsManager.instance.info),
                                          SessionLog(id: 2, type: SessionType.MAT ,date: Date(timeIntervalSinceNow: -245000.00), studentsInSession: StudentsManager.instance.info),
                                          SessionLog(id: 3, type: SessionType.GAP ,date: Date(timeIntervalSinceNow: -45000.00), studentsInSession: StudentsManager.instance.info)
        ]
        
    }
    
    func loadSimStudents() {
        StudentsManager.instance.latestId = 5
        StudentsManager.instance.info =  [Student(id: 1, name: "Valeria", lastName: "Torres", email: "x", observation: nil),
                                          Student(id: 2, name: "Myrna", lastName: "Yee", email: "y", observation: nil),
                                          Student(id: 3, name: "Laura", lastName: "Garcia", email: "m", observation: nil),
                                          Student(id: 4, name: "Monica", lastName: "Nose", email: "j", observation: "Se cansa muy rapido"),
                                          Student(id: 5, name: "Lupita", lastName: "Rodriguez", email: "v", observation: nil)]
    }
}
