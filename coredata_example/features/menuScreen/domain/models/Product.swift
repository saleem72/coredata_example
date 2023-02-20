//
//  Product.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation

struct Product: Identifiable {
    
    let entity: ProductEntity
    
    var id: Int {
        Int(entity.id)
    }
    
//    let barcode: String
//    let categoryId: Int
//    let code: String
    
    
    var description: String {
        entity.info ?? ""
    }
    var discount: Int {
        Int(entity.discount)
    }
    
//    let expectedTime: String?
    var image: String? {
        entity.image
    }
    
    var isAvailable: Bool {
        entity.isAvailable
    }
    var name: String {
        entity.name ?? ""
    }
    
    var offerId: Int? {
        //
        entity.offerId == nil ? nil : Int(truncating: entity.offerId ?? 0)
    }
    var price: Double {
        entity.price
    }
//    let restaurantId: Int?
    var size: String {
        entity.size ?? ""
    }
//    let sliderImage: String?
    var sort: Int {
        Int(entity.sort)
    }
    var cartCount: Int {
        Int(entity.cartCount)
    }
    
    static var example: Product {
        let product = ProductEntity()
        product.id = Int16(652)
        product.barcode = "8683581659885"
        product.categoryId = Int16(11)
        product.code = "SUTAS010"
        product.info = "بودينغ مرسين بالفراولة"
        product.discount = Int16(0)
        product.image = "https://api-alliba.codersdc.net/alliba-api/storage/product/images/q79SYVUZxkdoe1HNJMPGlxrrFeV89MCnlH6CP3RB.jpg"
        product.isAvailable = true
        product.name = "PUDING STRAWBERRY 100 GR"
        product.price = 7
        product.restaurantId = Int16(1)
        product.size = "24 Per Box"
        product.sort = Int16(0)
        product.cartCount = 0
        
        return Product(entity: product)
    }
}
