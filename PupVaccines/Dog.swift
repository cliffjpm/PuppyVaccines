//
//  Dog.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 10/19/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log


class Dog: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var dob: Date?
    var sex: String?
    var photo: UIImage?
    
    //DICTIONARIES unordered pair of key, value pairs of vaccines
    var vaccineDates: [String: Date]? = [:]
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let dob = "dob"
        static let sex = "sex"
        static let photo = "photo"
        static let vaccineDates = "vaccineDates"
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dogs")
    
    
    //MARK: Initialization
    
    init?(name: String, dob: Date?, sex: String?, photo: UIImage?, vaccineDates: Dictionary<String, Date>?) {
        
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        guard (sex == "Male") || (sex == "Female") || (sex == nil) else{
                return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.dob = dob
        self.sex = sex
        self.photo = photo
        self.vaccineDates = vaccineDates
        
    }
    
    convenience init?(name: String, dob: Date?, sex: String?, photo: UIImage?){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let day1 = formatter.date(from: "2016/10/08")
        let day2 = formatter.date(from: "2017/11/09")
        let day3 = formatter.date(from: "2018/12/010")
        let vDates = ["Rabies": day1!, "HeartGuard": day2!, "Flea & Tick": day3!]
        self.init(name: name, dob: dob, sex: sex, photo: photo, vaccineDates: vDates)
        //os_log("These dogs were initialized with a Vaccine Dictionary.", log: OSLog.default, type: .debug)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dob, forKey: PropertyKey.dob)
        aCoder.encode(sex, forKey: PropertyKey.sex)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(vaccineDates, forKey: PropertyKey.vaccineDates)
        //os_log("Encoding the Vaccine Dictionary was successful.", log: OSLog.default, type: .debug)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Dog object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo, dob and sex are optional properties of Dog,  use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let dob = aDecoder.decodeObject(forKey: PropertyKey.dob) as? Date
        let sex = aDecoder.decodeObject(forKey: PropertyKey.sex) as? String
        let vaccineDates = aDecoder.decodeObject(forKey: PropertyKey.vaccineDates) as? Dictionary<String, Date>
        //os_log("Decoding the Vaccine Dictionary was successful.>", log: OSLog.default, type: .debug)
        //print(vaccineDates)
        
        
    
        // Must call designated initializer.
        self.init(name: name, dob: dob, sex: sex, photo: photo, vaccineDates: vaccineDates)
        
    }
    
}
