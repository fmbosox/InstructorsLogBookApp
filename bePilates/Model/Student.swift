//
//  Student.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

/*  Defined a struct Student with 5 properties and 5 computed properties to protect our data of directly modifications.
 
 An object of Student will have all the information we need from a Student
 
 */

import Foundation


struct Student {
    private var _name: String
    private var _lastName: String
    private var _email: String
    private var _observation: String?
    private let _id: Int
    
    
//computed properties section
    var  id: Int {
        return _id
    }
    
    var  name: String  {
        get {
            return _name
        } set {
            _name = newValue
            print(_name)
        }
    }
    
    var  lastName: String  {
        get {
            return _lastName
        } set {
            _lastName = newValue
        }
    }
    
    var  email: String  {
        get {
            return _email
        } set {
            _email = newValue
        }
    }
    
    var  observation: String  {
        get {
            if let unwrappedObservation = _observation {
                return unwrappedObservation
            } else {
                return ""
            }
        } set {
            _observation = newValue
        }
    }
    
// methods sections
    
    init(id: Int, name: String, lastName: String, email: String, observation: String?) {
        _id = id
        _name = name
        _lastName = lastName
        _email = email
        _observation = observation
    }

    
    
}
