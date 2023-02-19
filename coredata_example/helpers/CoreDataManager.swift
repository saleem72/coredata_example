//
//  CoreDataManager.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: Keys.model.rawValue)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Can't find DB: \(error.localizedDescription)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    
}

extension CoreDataManager {
    enum Keys: String {
        case model = "MenuDB"
        case category = "CategoryEntity"
        case subCategory = "SubCategoryEntity"
        case product = "ProductEntity"
    }
}
