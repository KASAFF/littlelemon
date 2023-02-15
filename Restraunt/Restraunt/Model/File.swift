//
//  File.swift
//  Restraunt
//
//  Created by Aleksey Kosov on 15.02.2023.
//

import CoreData

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
