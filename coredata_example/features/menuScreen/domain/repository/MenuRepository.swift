//
//  MenuRepository.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import Combine

protocol MenuRepository {
    var products: PassthroughSubject<[Product], Never> {get}
    var subCategories: PassthroughSubject<[SubCategory], Never> {get}
    var categories: PassthroughSubject<[Category], Never> {get}
    
    
    var activeCategory: CurrentValueSubject<Int?, Never> {get}
    var activeSubCategory: CurrentValueSubject<Int?, Never> {get}
    
    func getMenu(handler: @escaping (Result<RestaurantMenu, Error>) -> ())
    func setActiveCategory(categoryId: Int)
    func setActiveSubCategory(subCategoryId: Int?)
}
