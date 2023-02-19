//
//  ApiGenericResponse.swift
//  MusicApp
//
//  Created by Yousef on 11/18/21.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let data: T?
    let status: Bool
    let  message: String?
    let code: Int
}

