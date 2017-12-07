//
//  Simulation&Keys.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

/*  Defined a struct PropertyKeys  to hold keys to use across the project.
    Defined a Class Simulate with a Static property o Singleton, 1 property and a method.
 
 An object of Simulate will help in the simulation enviroment.
 
 */

import Foundation

struct PropertyKeys {
    // Add keys that you want to use acrros your project
    
    
    static let DATE_FORMAT = "dd-MMM"
    static let HOUR_FORMAT = "K:mm a"
    static let MAT_STRING = "MAT"
    static let GAP_STRING = "GAP"
    static let CANCELLED_STRING = "CANCELLED"
    
}

class Simulate {
    
    static let instance = Simulate()
    
  
    let students: [Student] = [Student(id: 1, name: "Valeria", lastName: "Torres", email: "x", observation: nil),
                               Student(id: 2, name: "Myrna", lastName: "Yee", email: "y", observation: nil),
                               Student(id: 3, name: "Laura", lastName: "Garcia", email: "m", observation: nil),
                               Student(id: 4, name: "Monica", lastName: "Nose", email: "j", observation: "Se cansa muy rapido"),
                               Student(id: 5, name: "Lupita", lastName: "Rodriguez", email: "v", observation: nil)]
    
    
    //Methods section
    
    func beginSimulation () {
        InstructorRecords.instance.latestId = 3
        InstructorRecords.instance.info = [SessionLog(id: 1, type: SessionType.MAT ,date: Date(timeIntervalSinceNow: -445000.00), studentsInSession: self.students),
                                          SessionLog(id: 2, type: SessionType.MAT ,date: Date(timeIntervalSinceNow: -245000.00), studentsInSession: self.students),
                                          SessionLog(id: 3, type: SessionType.GAP ,date: Date(timeIntervalSinceNow: -45000.00), studentsInSession: self.students)
        ]
    }
}
