//
//  Joueurs+CoreDataProperties.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//
//

import Foundation
import CoreData


extension Joueurs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joueurs> {
        return NSFetchRequest<Joueurs>(entityName: "Joueurs")
    }

    @NSManaged public var nom: String?
    @NSManaged public var prenom: String?
    @NSManaged public var ensembledesscores: NSSet?

}

// MARK: Generated accessors for ensembledesscores
extension Joueurs {

    @objc(addEnsembledesscoresObject:)
    @NSManaged public func addToEnsembledesscores(_ value: Scores)

    @objc(removeEnsembledesscoresObject:)
    @NSManaged public func removeFromEnsembledesscores(_ value: Scores)

    @objc(addEnsembledesscores:)
    @NSManaged public func addToEnsembledesscores(_ values: NSSet)

    @objc(removeEnsembledesscores:)
    @NSManaged public func removeFromEnsembledesscores(_ values: NSSet)

}

extension Joueurs : Identifiable {

}
