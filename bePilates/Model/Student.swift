//
//  Student.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/2/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

/*  Defined a struct Student with 5 properties and 5 computed properties to protect our data of directly modifications. It has 2 initializers, one of them can return nil. It has a method.
 
 The convertLogToJSON method converts the Student into a Dictonary, useful to save it to the database.
 
 An object of Student will have all the information we need from a Student
 
 */

import Foundation

struct Student {
    private var _name: String
    private var _lastName: String
    private var _email: String?
    private var _observation: String?
    private let _id: Int
    
    //MARK: Computed properties
    
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
            return _email != nil ? _email! : ""
        } set {
            _email = newValue != "" ? newValue : nil
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
           _observation = newValue != "" ?  newValue : nil
        }
    }
    
    //MARK: Methods
    
    init(id: Int, name: String, lastName: String, email: String, observation: String?) {
            _id = id
            _name = name
            _lastName = lastName
            _email = email  != "" ? email : nil
            _observation = observation != nil && observation! != "" ? observation : nil
    }
    
    init?(_ ID: String ,_ studentData: Dictionary<String, AnyObject>)  {
            guard let name = studentData["name"] as? String, let lastName = studentData["last_name"] as? String else { return nil }
                _id = Int(ID)!
                _name = name
                _lastName = lastName
                _email =  studentData["email"] as? String
                _observation = studentData["observation"] as? String
    }
    
    func convertStudentToJSON () -> [String : Any]{
            var aJSON = [String : Any]()
            aJSON["name"] = self._name
            aJSON["last_name"] = self._lastName
            aJSON["email"] = _email != nil ? self._email! : nil
            aJSON["observation"] = _observation != nil ? self._observation! : nil
            return aJSON
    }

}
