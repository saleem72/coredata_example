//
//  MenuService.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import Combine

protocol MenuService {
    func getMenu() -> AnyPublisher<[CategoryDTO], HttpServiceError>
}
