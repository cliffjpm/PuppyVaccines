//
//  DogViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 10/11/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log


class DogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
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
    

    //MARK: Navigations
    // This method lets you configure a view controller before it's presented.
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        
        let name = dogNameField.text ?? ""
        let dob = dobSelected
        let sex = sexSelected
        let photo = photoImageView.image
        
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        dog = Dog(name: name, dob: dob, sex: sex, photo: photo)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        os_log("I understand you want to Cancel", log: OSLog.default, type: .debug)// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

