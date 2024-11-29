//
//  CDRepository+CoreDataProperties.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//
//

import Foundation
import CoreData


extension CDRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRepository> {
        return NSFetchRequest<CDRepository>(entityName: "CDRepository")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var desc: String?
    @NSManaged public var stars: Int64
    @NSManaged public var forks: Int64
    @NSManaged public var updatedAt: Date

}

extension CDRepository : Identifiable {
    func convertoRepository() -> Repository {
        return Repository(id: Int(self.id), name: self.name, description: self.desc, forksCount: Int(self.forks), starsCout: Int(self.stars), updatedAt: ISO8601DateFormatter().string(from: self.updatedAt))
    }
}
