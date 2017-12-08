//
//  VaccineDetailViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 12/8/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit

class VaccineDetailViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    //MARK: Properties (Outlets)
    @IBOutlet weak var medsText: UITextField!
    @IBOutlet weak var datesText: UITextField!
    
    var dateFormatter : DateFormatter!
    let datePicker = UIDatePicker()
    
    var dateSelected: Date?
    
    let meds = ["Select Med", "Rabies",  "Flea & Tick", "HeartGuard"]
    var medSelected: String?
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        //textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.isEnabled = false
    }
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
