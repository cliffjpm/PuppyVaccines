//
//  DogViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 10/11/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log


class DogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    
    //MARK: Properties (Outlets)
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dogNameField: UITextField!
    @IBOutlet weak var sexPicker: UIPickerView!
    @IBOutlet weak var birthDateTxt: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `DogTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new dog.
     */
    var dog: Dog?
    
    var dateFormatter : DateFormatter!
    let datePicker = UIDatePicker()
  
    var dobSelected: Date?
    
    let sex = ["Sex", "Male", "Female"]
    var sexSelected: String?
    
    var meds: [String] = []
    var dates: [Date] = []
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
         birthDateTxt.inputAccessoryView = toolbar
        
        //assign date picker to text field
        birthDateTxt.inputView = datePicker
    }
    
    @objc func dateDonePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        birthDateTxt.text = dateFormatter.string(from: datePicker.date)
        dobSelected = datePicker.date
        self.view.endEditing(true)
    }
    
    //MARK: Vaccine TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if dog?.vaccineDates?.count == nil {
            numberOfRows = 0
        }
        else {
            numberOfRows = (dog?.vaccineDates?.count)!
        }
        return (numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "VaccineTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VaccineTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DogTableViewCell.")
        }
        
        cell.dogMeds?.text = meds[indexPath.row]
        
        //Set up the date formatter before assigning the date to dogMedDates
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        cell.dogMedDates?.text = dateFormatter.string(from: dates[indexPath.row])
        
        return(cell)
    }
    

    //MARK: Navigations
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            
            //os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            
            switch(segue.identifier ?? "") {
                
            case "AddVaccine":
                os_log("Adding a new vaccine.", log: OSLog.default, type: .debug)
                
            case "ShowVaccineList":
                //os_log("Reached the Show Vaccine List case.", log: OSLog.default, type: .debug)
                guard let vaccineDetailViewController = segue.destination as? VaccineTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                vaccineDetailViewController.dog = dog
            case "ShowDetail":
                guard let dogDetailViewController = segue.destination as? DogTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                os_log("Saving changes and restoring Dog List View.", log: OSLog.default, type: .debug)
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
            
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let name = dogNameField.text ?? ""
        let dob = dobSelected
        let sex = sexSelected
        let photo = photoImageView.image
        let vDates = dog?.vaccineDates
        //os_log("Array of Vaccine Dates is populated", log: OSLog.default, type: .debug)
        //print(vDates)
        
        // Set the dog to be passed to DogTableViewController after the unwind segue.
        dog = Dog(name: name, dob: dob, sex: sex, photo: photo, vaccineDates: vDates)
        //os_log("Dog created to pass to DogTavleViewController", log: OSLog.default, type: .debug)
       
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //os_log("I understand you want to Cancel", log: OSLog.default, type: .debug)
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        dogNameField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sex[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sex.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //he sex must not be "Sex"
        if (sex[row] == "Sex") {
            sexSelected = nil
            
        }
        else {
            sexSelected = sex[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: (pickerLabel?.font?.fontName)!, size: 13)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = sex[row]
        pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthDateTxt.font = UIFont(name: (birthDateTxt.font?.fontName)!, size: 13)

        // Handle the text field’s user input through delegate callbacks.
        dogNameField.delegate = self
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd 'T' hh:mm"
        
        createDatePicker()
        
    // Set up views if editing an existing Dog.
        if let dog = dog {
            dogNameField.text = dog.name
            photoImageView.image = (dog.photo ?? nil)
            if dog.dob != nil {
                datePicker.date = dog.dob!
                dateDonePressed()
                
            } else {
                dobSelected = nil
                birthDateTxt.text = "Select Birthday"
            }
            
            sexSelected = (dog.sex ?? "")
            switch(dog.sex ?? "") {
                
            case "":
                sexPicker.selectRow(0, inComponent: 0, animated: true)
            
            case "Male":
                sexPicker.selectRow(1, inComponent: 0, animated: true)
                
            case "Female":
                sexPicker.selectRow(2, inComponent: 0, animated: true)
           
            default:
                fatalError("Unexpected Sex Identifier; \(dog.sex!)")
            }
            
            //For an existing dog, were vaccines exist, show a list with the most recent date
            if dog.vaccineDates != nil {
                for vaccines in dog.vaccineDates! {
                    meds.append(vaccines.key)
                    dates.append((vaccines.value?.max())!)
                }
            }
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = dogNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

