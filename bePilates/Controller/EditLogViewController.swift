//
//  EditLogViewController.swift
//  bePilates
//
//  Created by Felipe Montoya on 4/4/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class EditLogViewController: UIViewController  {
    
    //MARK: - Variables
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.borderWidth = 1.97
            containerView.layer.shadowRadius  = 5.0
            containerView.layer.shadowOpacity = 0.8
            containerView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
            containerView.layer.shadowColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var changeSessionTypeButton: UIButton!
    @IBOutlet weak var sessionTypeContainerView: UIView!
    {
        didSet {
            //sessionTypeContainerView.layer.cornerRadius = 31.0
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
  //  @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
 //   @IBOutlet weak var changeTimeButton: UIButton!
    @IBOutlet weak var studentsTableView: UITableView!
    

    let dateFormatter: DateFormatter = DateFormatter()
    let hourFormatter: DateFormatter = DateFormatter()
    
    @objc func goToPreviousVC () {
        if !datePickerContainerView.isHidden {
            dismissPickerViewContainer()
        } else {
            performSegue(withIdentifier: "Unwind To RecordsVC From EditVC", sender: nil)
        }
    }
    
    
    
    @IBOutlet weak var optOutView: UIView! {
        didSet{
            let touchEvent = UITapGestureRecognizer(target: self, action: #selector(goToPreviousVC))
            optOutView.addGestureRecognizer(touchEvent)
        }
    }
    
    var selectedIndex: Int?
    var students: [Student] = []
    
    
    
    func  setTypeContainerColor(for type:SessionType) {
        switch type as SessionType {
        case .GAP, .MAT,.AERO :  sessionTypeContainerView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.3921568627, blue: 0.6078431373, alpha: 1)
            containerView.layer.borderColor = #colorLiteral(red: 0.1960784314, green: 0.3921568627, blue: 0.6078431373, alpha: 1)
        case .CANCELLED_AERO, .CANCELLED_MAT, .CANCELLED_GAP: sessionTypeContainerView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.3058823529, blue: 0.2784313725, alpha: 1)
            containerView.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.3058823529, blue: 0.2784313725, alpha: 1)
        }
    }
    //MARK: - Initial Setup
    
    
    func setTypeButton(for type: SessionType) {
        switch type as SessionType {
        case .GAP:
            changeSessionTypeButton.setTitle("GAP", for: .normal)
        case .CANCELLED_GAP:
            changeSessionTypeButton.setTitle("XGAP", for: .normal)
        case .MAT:
            changeSessionTypeButton.setTitle("MAT", for: .normal)
        case .CANCELLED_MAT: changeSessionTypeButton.setTitle("XMAT", for: .normal)
        case .AERO: changeSessionTypeButton.setTitle("AEREO", for: .normal)
        case .CANCELLED_AERO: changeSessionTypeButton.setTitle("XAEREO", for: .normal)
        }
        setTypeContainerColor(for: type)
    }
    
    /* In case RecordsViewController passes an Index, AddEditLogViewController has to set the initial information based on the Log
     that the users wants to see, using the following method
     */
    func setLogInformation(with log:SessionLog) {
        setTypeButton(for: log.type)
        dateLabel.text = dateFormatter.string(from: log.date)
        timeLabel.text = hourFormatter.string(from: log.date)
        datePicker.date = log.date
        students = log.studentsInSession
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = PropertyKeys.DATE_FORMAT
        hourFormatter.dateFormat = PropertyKeys.HOUR_FORMAT
        if let index = selectedIndex {
            setLogInformation(with: InstructorRecords.instance.info[index])
        } else {
            print("No index passed")
            fatalError()
        }
        studentsTableView.delegate = self
        studentsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePickerContainerView.isHidden = true
    }
    
    //MARK:- Saving a Log
    
    /*This method is called when we want to create and save a new log,
     or when we want to commit and submit the changes of one of the objects in the array.
     */
    func saveLogInformation() {
        if datePicker.date != InstructorRecords.instance.info[selectedIndex!].date {
            InstructorRecords.instance.info[selectedIndex!].date = datePicker.date
            let logDate = InstructorRecords.instance.info[selectedIndex!].date
            dateLabel.text = dateFormatter.string(from: logDate)
            timeLabel.text = hourFormatter.string(from: logDate)
        }
        
    }

    // MARK: - User interaction methods
    

    @IBAction func toggleSessionButton(_ sender: Any) {
        var type: SessionType?
        switch InstructorRecords.instance.info[selectedIndex!].type  as SessionType {
        case .AERO, .GAP, .MAT: switch InstructorRecords.instance.info[selectedIndex!].type  as SessionType {
        case .MAT: type = .CANCELLED_MAT
        case .GAP: type = .CANCELLED_GAP
        case .AERO: type = .CANCELLED_AERO
        default: break
            
            }
            
        case .CANCELLED_AERO, .CANCELLED_GAP, .CANCELLED_MAT:
            switch InstructorRecords.instance.info[selectedIndex!].type  as SessionType {
            case .CANCELLED_MAT: type = .MAT
            case .CANCELLED_GAP: type = .GAP
            case .CANCELLED_AERO: type = .AERO
            default: break
                
            }
            
        }
        InstructorRecords.instance.info[selectedIndex!].type = type!
        setTypeButton(for: type!)
    }
    

    @IBAction func updateDateButtonPressed(_ sender: Any) {
        datePicker.date = InstructorRecords.instance.info[selectedIndex!].date
        datePicker.datePickerMode = .date
        datePickerContainerView.isHidden = false
    }
    
    @IBAction func updateTimeButtonPressed(_ sender: Any) {
        datePicker.date = InstructorRecords.instance.info[selectedIndex!].date
         datePicker.datePickerMode = .time
         datePickerContainerView.isHidden = false
    }
    
    
    
    func dismissPickerViewContainer() {
        UIView.transition(with: datePickerContainerView, duration: 0.6, options: [.curveEaseInOut], animations: {
            self.datePickerContainerView.transform = CGAffineTransform(translationX: 0.0, y: 500.0)
        }, completion: { (sucess) in
            self.datePickerContainerView.transform = CGAffineTransform.identity
            self.datePickerContainerView.isHidden = true
        })
    }
    
    
    @IBAction func submitChangeButtonPressed(_ sender: Any) {
        saveLogInformation()
       dismissPickerViewContainer()
    }
    
}


    // MARK: - Extension: TableView Delegate
extension EditLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Student Cell") else { return UITableViewCell() }
        cell.textLabel?.text = students[indexPath.row].name + " " + students[indexPath.row].lastName
        return cell
    }
    
    
}




