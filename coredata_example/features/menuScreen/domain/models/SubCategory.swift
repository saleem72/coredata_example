//
//  SubCategory.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation

struct SubCategory: Identifiable {
    let entity: SubCategoryEntity
    var id: Int {
        Int(entity.id)
    }
//    let isActive: Bool
    var name: String {
        entity.name ?? ""
    }
    var parentId: Int {
        Int(entity.parentId)
    }
//    let restaurantId: Int?
//    let sort: Int
}
