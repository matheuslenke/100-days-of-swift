//
//  Country.swift
//  ReviewProject5-CountryFacts
//
//  Created by Matheus Lenke on 10/08/21.
//

import Foundation

struct Country: Codable {
    let name: String
    let capitalCity: String
    let size: Double
    let population: Int
    let currency: String
    let languages: [String]
    let president: String
    let flagImage: String
}
