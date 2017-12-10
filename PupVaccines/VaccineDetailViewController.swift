//
//  VaccineDetailViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 12/8/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log

class VaccineDetailViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {

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
        createDatePicker()
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
    
        for vaccineKeys in (dog?.vaccineDates)!{
            allKeys.append(vaccineKeys.key)
        }
        print("DEBUG")
        print(allKeys)
    
        if allKeys.contains(medSelected!){
            print("This one matches the keys")
            for vaccine in (dog?.vaccineDates)! {
                        if vaccine.key == medSelected {
                        var myDateArray = [dateSelected!]
                        dog?.vaccineDates![vaccine.key] = vaccine.value! + myDateArray
                    print("Updated an existing med with a new date")
                    print(dog?.vaccineDates)
                }
                        else{print("I matched the keys but I am not the right med")}
            }
        }
        else {
                print("This did not match the keys")
            dog?.vaccineDates![medSelected!] = [dateSelected!]
                print("Added an entirely new ned")
                print(dog?.vaccineDates)
        }

    
        // Set the dog to be passed to DogTableViewController after the unwind segue.
        dog = Dog(name: (dog?.name)!, dob: dog?.dob, sex: dog?.sex, photo: dog?.photo, vaccineDates: dog?.vaccineDates)
        os_log("Dog created to pass to vaccineTavleViewController", log: OSLog.default, type: .debug)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
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
}


