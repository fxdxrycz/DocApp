//
//  Patient.swift
//  DocApp
//
//  Created by Federico Dazzan on 24/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import Foundation
import RealmSwift

class Patient: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : String = ""
    @objc dynamic var cf : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var notes : String = ""
    @objc dynamic var selected : Bool = false
    @objc dynamic var dateCreated : Date?
}
