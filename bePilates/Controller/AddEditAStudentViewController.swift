//
//  AddEditAStudentViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 12/7/17.
//  Copyright © 2017 Felipe Montoya. All rights reserved.
//

import UIKit

class AddEditAStudentViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var observationsTextView: UITextView!
    @IBOutlet weak var stackViewofForm: UIStackView!
    
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
   // @IBOutlet weak var navigationBar:UINavigationBar!
    
    var selectedIndex: Int?

        // MARK: - Initial Setup

    @objc   func dismissKeyboard() {
        if stackViewofForm.frame.origin.y   != stackViewofForm.frame.origin.y  {
          stackViewofForm.frame.origin.y = 109
        }
        view.endEditing(true)
    }
    



    
    func initalConfiguration() {
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        observationsTextView.delegate = self
  
         rightBarButtonItem.isEnabled = true

        observationsTextView.text = ""
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let unwrappedSelectedIndex = selectedIndex {
            navItem.title = StudentsManager.instance.info[unwrappedSelectedIndex].name + " " + StudentsManager.instance.info[unwrappedSelectedIndex].lastName
            
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

        // MARK: - Saving a Student.
    
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
    
    
    // MARK: - Navigation
    
    
    @IBAction func dismissVC(sender: Any?){
        saveStudent()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddEditAStudentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
            stackViewofForm.frame.origin.y -= 195
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            stackViewofForm.frame.origin.y += 195
    }
    
}
