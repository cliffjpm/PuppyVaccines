//
//  VaccineDetailViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 12/8/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log

class VaccineDetailViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {

    //MARK: Properties (Outlets)
    @IBOutlet weak var datesText: UITextField!
    @IBOutlet weak var medPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var dateFormatter : DateFormatter!
    let datePicker = UIDatePicker()
    var dateSelected: Date?
    
    let meds = ["Select Med", "Rabies",  "Flea & Tick", "HeartGuard", "Pred"]
    var medSelected: String?

    /*
     This value is either passed by `VaccineTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new Vaccine Occurance.
     */
    var dog: Dog?

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return meds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //The med field must not be "Med"
        if (meds[row] == "Select Med") {
            medSelected = nil
            
        }
        else {
            medSelected = meds[row]
        }
        
        updateSaveButtonState()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: (pickerLabel?.font?.fontName)!, size: 13)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = meds[row]
        pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }
    
    func createDatePicker(){
        
        //format date picker
        datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneButton], animated: false)
        
        //connect the input for this field to the toolbar
        datesText.inputAccessoryView = toolbar
        
        //assign date picker to text field
        datesText.inputView = datePicker
    }
    
    @objc func dateDonePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        datesText.text = dateFormatter.string(from: datePicker.date)
        dateSelected = datePicker.date
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.medPicker.delegate = self
        self.medPicker.dataSource = self
        self.datesText.delegate = self
        createDatePicker()
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    // This method lets you configure a view controller before it's presented.
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button on Vaccine Detail was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    
        
        //For an existing dog, were vaccines exist, show a list with the most recent date
       os_log("The trouble is with the vaccine dictionary code", log: OSLog.default, type: .debug)
        var allKeys: [String] = []
    
    //TDDO: Test to see if this check for a nil value is required
    if (dog?.vaccineDates) == nil {
        let newMedDictionary = [medSelected!: [dateSelected!]]
        dog?.vaccineDates? = newMedDictionary
        //print(newMedDictionary)
        //("Setting up a new dog with the first med: " )
        //print(medSelected)
        //print(dateSelected)
        //dog?.vaccineDates![medSelected!] = [dateSelected!]
        //print(dog?.vaccineDates)
    }
    else {
        for vaccineKeys in (dog?.vaccineDates)!{
            allKeys.append(vaccineKeys.key)
        }
        //print("DEBUG")
        //print(allKeys)
    
        if allKeys.contains(medSelected!){
            //print("This one matches the keys")
            for vaccine in (dog?.vaccineDates)! {
                    //Update an existing med with a new date
                    if vaccine.key == medSelected {
                        dog?.vaccineDates![vaccine.key] = vaccine.value! + [dateSelected!]
                    }
                    else {
                        //Do nothing as it matched the keys but was not the right med
                }
            }
        }
        else {
            //Did not match the keys
            dog?.vaccineDates![medSelected!] = [dateSelected!]
            //Added an entirely new med
        }
    }
    }
    
    @IBAction func cancel(_ sender: Any) {
        //os_log("I understand you want to Cancel", log: OSLog.default, type: .debug)
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: UITextFieldDelegate
    //TODO: Test how much of this UITextField Delegate is required (e.g., resignFirstResponder)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        
        // Disable the Save button if the date is not set or there is no medication selected
        if (datesText.text == "Date") || (medSelected == nil){
            saveButton.isEnabled = false
           // print("DEBUG: save button disabled")
        }
        else {
          saveButton.isEnabled = true
            //print("DEBUG: save button enabled")
        }
    }

}


