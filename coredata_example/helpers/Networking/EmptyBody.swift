//
//  EmptyBody.swift
//  MusicApp
//
//  Created by Yousef on 11/20/21.
//

import Foundation

struct EmptyBody: Encodable {
    let categoryId: Int?
    
    init(categoryId: Int? = nil) {
        self.categoryId = categoryId
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
    }
}
