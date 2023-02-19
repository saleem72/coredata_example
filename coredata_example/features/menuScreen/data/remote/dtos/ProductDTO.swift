//
//  ProductDTO.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation

/*
 'barcode': barcode,
 'category_id': categoryId,
 'code': code,
 'description': description,
 'discount': discount,
 'expected_time': expectedTime,
 'id': productId,
 'image': image,
 'is_available': isAvailable,
 'name': name,
 'offer_id': offerId,
 'price': price,
 'restaurant_id': restaurantId,
 'size': size,
 'slider_image': sliderImage,
 'sort': sort,

 */

struct ProductDTO: Codable {
    let barcode: String?
    let categoryId: Int?
    let code: String?
    let description: String?
    let discount: Int?
    let expectedTime: String?
    let id: Int?
    let image: String?
    let isAvailable: Int?
    let name: String?
    let offerId: Int?
    let price: Double?
    let restaurantId: Int?
    let size: String?
    let sliderImage: String?
    let sort: Int?
    
    enum CodingKeys: String, CodingKey {
        case barcode
        case categoryId = "category_id"
        case code
        case description
        case discount
        case expectedTime = "expected_time"
        case id
        case image
        case isAvailable = "is_available"
        case name
        case offerId = "offer_id"
        case price
        case restaurantId = "restaurant_id"
        case size
        case sliderImage = "slider_image"
        case sort
    }
    
//    func toProduct() -> Product {
//        return Product(
//            productId: id ?? 0,
//            barcode: barcode ?? "",
//            categoryId: categoryId ?? 0,
//            code: code ?? "",
//            description: description ?? "",
//            discount: discount ?? 0,
//            expectedTime: expectedTime,
//            image: image,
//            isAvailable: isAvailable == 1 ? true : false,
//            name: name ?? "",
//            offerId: offerId,
//            price: price ?? 0,
//            restaurantId: restaurantId,
//            size: size ?? "",
//            sliderImage: sliderImage,
//            sort: sort ?? 0,
//            cartCount: 0
//        )
//    }
}
