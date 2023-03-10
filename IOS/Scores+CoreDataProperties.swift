//
//  Scores+CoreDataProperties.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//
//

import Foundation
import CoreData


extension Scores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scores> {
        return NSFetchRequest<Scores>(entityName: "Scores")
    }

    @NSManaged public var score: Int32
    @NSManaged public var date: Date?
    @NSManaged public var queljoueur: Joueurs?

}

extension Scores : Identifiable {

}
