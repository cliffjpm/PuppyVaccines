//
//  VaccineTableViewController.swift
//  PupVaccines
//
//  Created by Cliff Malcolm Anderson on 12/6/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log


class VaccineTableViewController: UITableViewController {
    
    //MARK: Properties
    var dog: Dog?
    
    //TO DO: Make an array of the meds and dates here then pass this to the table
    var meds: [String] = []
    var dates: [Date] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        

        
        //For an existing dog, were vaccines exist, show a list with the most recent date
        if dog?.vaccineDates != nil {
            for vaccines in (dog?.vaccineDates!)! {
                for occurances in (vaccines.value!) {
                    meds.append(vaccines.key)
                    dates.append(occurances)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: Remove these debug statements
        //var ss = "\(dates.count)"
        //print("The number of rows is \(ss)")
        //return (dog?.vaccineDates?.values.count)!
        return (dates.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "VaccineTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VaccineTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DogTableViewCell.")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        cell.vaccineMeds.text = meds[indexPath.row]
        cell.vaccineMedDates.text = dateFormatter.string(from: dates[indexPath.row])
        
        return cell
    }
 


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddMed":
            os_log("Adding a new med entry", log: OSLog.default, type: .debug)
            
            guard let vaccineDetailViewController = segue.destination as? VaccineDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
           
            vaccineDetailViewController.dog = dog
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
