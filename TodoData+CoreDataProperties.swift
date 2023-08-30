//
//  TodoData+CoreDataProperties.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/30.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var todoContent: String?
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: UUID
    @NSManaged public var month: String

}

extension TodoData : Identifiable {

}
