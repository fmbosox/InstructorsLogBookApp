//
//  AddEditAStudentViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/7/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditAStudentViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var observationsTextView: UITextView!
    
    var selectedIndex: Int?

    // It dismiss the Keyboard and sets the view to the corresponding initial state.
    @objc   func dismissKeyboard() {
        if self.view.frame.origin.y  != 0 {
            view.frame.origin.y = 0
        }
        view.endEditing(true)
    }
    
    // Sets the inital configuration of the viewController.
    func initalConfiguration() {
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        observationsTextView.delegate = self
        navigationItem.rightBarButtonItem!.isEnabled = false
        observationsTextView.text = ""
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let unwrappedSelectedIndex = selectedIndex {
            navigationItem.title = StudentsManager.instance.info[unwrappedSelectedIndex].name + " " + StudentsManager.instance.info[unwrappedSelectedIndex].lastName
            nameTextField.text = StudentsManager.instance.info[unwrappedSelectedIndex].name
            lastNameTextField.text = StudentsManager.instance.info[unwrappedSelectedIndex].lastName
            emailTextField.text = StudentsManager.instance.info[unwrappedSelectedIndex].email
            observationsTextView.text = StudentsManager.instance.info[unwrappedSelectedIndex].observation
        } else {
            navigationItem.title = "New Student"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         initalConfiguration()
    }

    // Saves a new or edited Student.
    func saveStudent() {
       if let unwrappedSelectedIndex = selectedIndex  {
            StudentsManager.instance.info[unwrappedSelectedIndex].name = nameTextField.text!
            StudentsManager.instance.info[unwrappedSelectedIndex].lastName = lastNameTextField.text!
            StudentsManager.instance.info[unwrappedSelectedIndex].email =  emailTextField.text!
            StudentsManager.instance.info[unwrappedSelectedIndex].observation = observationsTextView.text
            StudentsManager.instance.saveEdited(unwrappedSelectedIndex)
        } else { // A New Student!
            if let name = nameTextField.text, let lastName = lastNameTextField.text{
                if let email = emailTextField.text {
                    StudentsManager.instance.saveNewStudent(name: name, lastName: lastName, email: email, observation: observationsTextView.text)
                } else {
                    StudentsManager.instance.saveNewStudent(name: name, lastName: lastName, email: "", observation: observationsTextView.text)
                }
            }
        }
    }
    
    // Enables the Save Button given the correct conditions.
    func enableRightBarButtonItem() {
        if let text1 = nameTextField.text, let text2 = lastNameTextField.text {
            if !text1.isEmpty && !text2.isEmpty {
                navigationItem.rightBarButtonItem!.isEnabled = true
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveAStudentUnwind" else { return }
            saveStudent()
    }
    
}

extension AddEditAStudentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableRightBarButtonItem()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        enableRightBarButtonItem()
        return true
    }
    
}

extension AddEditAStudentViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.view.frame.origin.y  == 0 {
            self.view.frame.origin.y -= 200
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.view.frame.origin.y  != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
