//
//  Category.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation

struct Category: Identifiable {
    let entity: CategoryEntity
    var id: Int {
        Int(entity.id)
    }
//    var isActive: Bool
    var name: String {
        entity.name ?? ""
    }
//    var restaurantId: Int?
//    var sort: Int
}
