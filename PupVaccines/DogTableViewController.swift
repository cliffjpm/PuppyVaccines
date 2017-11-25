//
//  DogTableViewController.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 10/20/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit
import os.log

class DogTableViewController: UITableViewController {
    
    //MARK: Properties
    var dogs = [Dog]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved dogs, otherwise load sample data.
        if let savedDogs = loadDogs() {
            dogs += savedDogs
        }
        else {
            // Load the sample data.
            loadSamples()
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
        return dogs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DogTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DogTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DogTableViewCell.")
        }

        // Fetches the appropriate dog for the data source layout.
        let dog = dogs[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        cell.dogImage.image = dog.photo
        cell.dogName.text = dog.name
        if dog.dob == nil {
            cell.dogDOB.text = ""
        } else {
            cell.dogDOB.text = dateFormatter.string(from: dog.dob!)
        }
        cell.dogSex.text = dog.sex
        
        return cell
        
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dogs.remove(at: indexPath.row)
            //Save the new Dog
            saveDogs()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddPup":
            os_log("Adding a new dog.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let dogDetailViewController = segue.destination as? DogViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDogCell = sender as? DogTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDogCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDog = dogs[indexPath.row]
            dogDetailViewController.dog = selectedDog
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToDogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DogViewController, let dog = sourceViewController.dog {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing dog.
                dogs[selectedIndexPath.row] = dog
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a dog meal.
                let newIndexPath = IndexPath(row: dogs.count, section: 0)
                
                dogs.append(dog)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the new Dog
            saveDogs()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSamples(){
        let photo1 = UIImage(named: "win")
        let photo2 = UIImage(named: "suki")
        let photo3 = UIImage(named: "albus")
        let today = Date()
        
        guard let dog1 = Dog(name: "Winnie", dob: today, sex: "Female", photo: photo1) else {
            fatalError("Unable to instantiate dog1")
        }
        
        guard let dog2 = Dog(name: "Suzi", dob: nil, sex: "Female", photo: photo2) else {
            fatalError("Unable to instantiate dog2")
        }
        
        guard let dog3 = Dog(name: "Albus", dob: nil, sex: nil, photo: photo3) else {
            fatalError("Unable to instantiate dog3")
        }
        
        
       dogs += [dog1, dog2, dog3]
    
        
    }
    
    private func saveDogs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dogs, toFile: Dog.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Dogs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save dogs...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDogs() -> [Dog]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Dog.ArchiveURL.path) as? [Dog]
    }
    

}
