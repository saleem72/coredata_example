//
//  RestaurantMenu.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation

struct RestaurantMenu {
    let categories: [Category]
    let subCategories: [SubCategory]
    let products: [Product]
    let activeCategory: Int?
    let activeSubCategory: Int?
}
