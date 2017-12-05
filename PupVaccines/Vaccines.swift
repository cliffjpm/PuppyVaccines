//
//  Vaccines.swift
//  PupVaccines
//
//  Created by Cliff Anderson on 12/2/17.
//  Copyright © 2017 ArenaK9. All rights reserved.
//

import UIKit

class Vaccines: NSObject {

    var vaccines: [String: Array<Date>?] = [:]

    init?(records: [String: Array<Date>?]){
    
        self.vaccines = records
       
    }
}
