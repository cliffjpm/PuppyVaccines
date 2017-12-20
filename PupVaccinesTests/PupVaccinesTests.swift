//
//  PupVaccinesTests.swift
//  PupVaccinesTests
//
//  Created by Cliff Anderson on 10/11/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import XCTest
@testable import PupVaccines

class PupVaccinesTests: XCTestCase {
    
    //MARK Dog Class Tests
    
    //Confirm that the Dog initializer returns a Dog object when passed valid parameters.
    func testDogInitializationSucceeds() {
        
        // Dog not created as there is no name
        let noNameDog = Dog.init(name: "", dob: nil, sex: nil, photo: nil)
        XCTAssertNil(noNameDog)
        
        // Created with a name only
        let nameOnlyDog = Dog.init(name: "Seb", dob: nil, sex: nil, photo: nil)
        XCTAssertNotNil(nameOnlyDog)
        
        // Created with a name and a date only
        let today = Date()
        let nameDOBDog = Dog.init(name: "Seb", dob: today, sex: nil, photo: nil)
        XCTAssertNotNil(nameDOBDog)
        
        //Create with name, date and pic
        let image = UIImage(named: "defaultPhoto")
        let nameImageDog = Dog.init(name: "Seb", dob: today, sex: nil, photo: image)
        XCTAssertNotNil(nameImageDog)
        
        //Creating and intialize all
        let bigDog = Dog.init(name: "Seb", dob: today, sex: "Male", photo: image)
        XCTAssertNotNil(bigDog)
        
        //Create dog with wrong sex
        let badDog = Dog.init(name: "Seb", dob: today, sex: "Mole", photo: nil)
        XCTAssertNil(badDog)
        
        //Create dog with wrong sex
        let sexAsSpaceDog = Dog.init(name: "Seb", dob: today, sex: "", photo: nil)
        XCTAssertNil(sexAsSpaceDog)
    }
    
}
