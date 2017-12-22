//
//  Manager.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/21/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//
/*
 Defined a protocol Manager with a class property or Singleton, it also has 3 required methods for any class the implements this protocol.


The appendFromFirebase method loads information coming from the Firebase database.

The removeAt method removes information from the array and calls DataService.

The saveEdited method its called when the users wants to edit existing data and calls DataService.

*/
protocol Manager {
    func appendFromFirebase(_ firebaseRawJSON: (ID: String, rawJSON: AnyObject))
    func removeAt(_ index: Int)
    func saveEdited(_ index: Int)
}
