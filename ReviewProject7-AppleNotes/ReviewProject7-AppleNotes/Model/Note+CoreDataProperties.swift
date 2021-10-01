//
//  Note+CoreDataProperties.swift
//  ReviewProject7-AppleNotes
//
//  Created by Matheus Lenke on 01/10/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension Note : Identifiable {

}
