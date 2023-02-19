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
    
    /*
     {
         "id": 652,
         "name": "PUDING STRAWBERRY 100 GR",
         "description": "بودينغ مرسين بالفراولة",
         "image": "https://api-alliba.codersdc.net/alliba-api/storage/product/images/q79SYVUZxkdoe1HNJMPGlxrrFeV89MCnlH6CP3RB.jpg",
         "slider_image": null,
         "size": "24 Per Box",
         "expected_time": null,
         "price": 7,
         "discount": null,
         "sort": 23,
         "is_available": 1,
         "category_id": 11,
         "category_name": "Dairy",
         "parent_category_name": "MERSIN",
         "restaurant_id": 1,
         "code": "SUTAS010",
         "barcode": "8683581659885",
         "offer": null,
         "offer_id": null
     }

     */
    
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
    
    static func dummyData(complition: (Product) -> Void) {
        Bundle.main.ObjectFromJson(type: ProductDTO.self, fileName: "SearchHistory.json") {  response in
            switch response {
            
            case .success(let productDTO):
                let product = ProductEntity()
                product.id = Int16(productDTO.id ?? 0)
                product.barcode = productDTO.barcode ?? ""
                product.categoryId = Int16(productDTO.categoryId ?? 0)
                product.code = productDTO.code ?? ""
                product.info = productDTO.description ?? ""
                product.discount = Int16(productDTO.discount ?? 0)
                product.expectedTime = productDTO.expectedTime
                product.image = productDTO.image
                product.isAvailable = productDTO.isAvailable == 1 ? true : false
                product.name = productDTO.name ?? ""
                if productDTO.offerId != nil {
                    product.offerId = NSNumber(value: productDTO.offerId ?? 0)
                }
                
                product.price = productDTO.price ?? 0
                product.restaurantId = Int16(productDTO.restaurantId ?? 0)
                product.size = productDTO.size ?? ""
                product.sliderImage = productDTO.sliderImage
                product.sort = Int16(productDTO.sort ?? 0)
                product.cartCount = 0
                complition( Product(entity: product))
            case .failure(let error):
                fatalError("Can't decode json \(error.localizedDescription)")
            }
        }
    }
}
