//
//  Event+CoreDataProperties.swift
//  UnadecaAgenda
//
//  Created by ISC Devolpers on 27/1/21.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: Int64
    @NSManaged public var init_date: String?
    @NSManaged public var end_date: String?
    @NSManaged public var title: String?
    @NSManaged public var event_description: String?
    @NSManaged public var color_code: String?
    @NSManaged public var all_day: Bool

}

extension Event : Identifiable {

}
