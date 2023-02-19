//
//  SubCategoryDTO.swift
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
 'products': products?.map((x) => x.toMap()).toList(),
 'restaurantId': restaurantId,
 'sort': sort,
 */

struct SubCategoryDTO: Decodable {
    let id: Int?
    let isActive: Int?
    let name: String?
    let parentId: Int?
    let products: [ProductDTO]?
    let restaurantId: Int?
    let sort: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case name
        case parentId = "parent_id"
        case products
        case restaurantId = "restaurant_id"
        case sort

    }
    
//    func toSubCategory() -> SubCategory {
//        return SubCategory(
//            id: id ?? 0,
//            isActive: isActive == 1 ? true : false,
//            name: name ?? "",
//            parentId: parentId ?? 0,
//            restaurantId: restaurantId,
//            sort: sort ?? 0
//        )
//    }
}
