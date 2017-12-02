//
//  Vaccines.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 12/2/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit


class Vaccines: NSObject {
    
    /*  Set up three data types:
     an array of Vaccine Types
     and arry of the Dates of Occurance and
     Dictionary of the types (String) and the array of days (Dates) they occurred*/
    var vaccineTypes = [String]()
    var vaccineOccurances = [Date]()
    var vaccines: [String: Array<Date>?] = [:]

    init?(records: [String: Array<Date>?]){
    
        //Date formatter with default dates for testing
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let day1 = formatter.date(from: "2016/10/08")
        let day2 = formatter.date(from: "2018/11/10")
        let day3 = formatter.date(from: "2017/12/09")

        //Set up the types available
        vaccineTypes = ["Rabies",  "Flea & Tick", "HeartGuard"]

        //Create an emply array of Dictionary
        vaccines = [vaccineTypes[0]: nil, vaccineTypes[1]: nil, vaccineTypes[2]: nil]

        vaccineOccurances = [day1!, day2!, day3!]
        vaccineOccurances.sort()
        //vaccineOccurances.max()

        for dateOfOccurances in vaccineOccurances{
            print(dateOfOccurances)
        }

        //Set up some sample dates
        vaccines = [vaccineTypes[0]: vaccineOccurances, vaccineTypes[1]: vaccineOccurances, vaccineTypes[2]: vaccineOccurances]

        //Add a date to one oin the array
        vaccines["Rabies"]??.append(formatter.date(from: "2020/10/08")!)

        for meds in vaccines{
            print(meds.key + "")
    
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
    
            var latestMed: String
            latestMed = dateFormatter.string(from: (meds.value?.max())!)
    
            print(latestMed)
        }
    }
}
