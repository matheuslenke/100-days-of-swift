//
//  Person.swift
//  Project10-PeopleNames
//
//  Created by Matheus Lenke on 24/07/21.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
