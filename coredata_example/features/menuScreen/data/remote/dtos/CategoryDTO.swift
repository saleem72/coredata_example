//
//  CategoryDTO.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
/*
 
 'id': id,
 'is_active': isActive,
 'name': name,
 'parent_id': parentId,
 'restaurantId': restaurantId,
 'sort': sort,
 'subcategories': subcategories?.map((x) => x.toMap()).toList(),
 */

struct CategoryDTO: Decodable {
    let id: Int?
    let isActive: Int?
    let name: String?
    let restaurantId: Int?
    let sort: Int?
    let subCategories: [SubCategoryDTO]?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case name
        case restaurantId = "restaurant_id"
        case sort
        case subCategories = "subcategories"
    }
    
//    func toCategory() -> Category {
//        return Category(
//            id: id ?? 0,
//            isActive: isActive == 1 ? true : false,
//            name: name ?? "",
//            restaurantId: restaurantId,
//            sort: sort ?? 0
//        )
//    }
    
}
