//
//  Patient.swift
//  DocApp
//
//  Created by Federico Dazzan on 23/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import Foundation

//the Encodable part only works if all the data types of my class are simple data tipes and not other classes
class Patient: Encodable, Decodable {
    var name: String = ""
    var selected: Bool = false
}
