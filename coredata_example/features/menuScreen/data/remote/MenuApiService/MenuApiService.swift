//
//  MenuApiService.swift
//  coredata_example
//
//  Created by Yousef on 2/14/23.
//

import Foundation
import Combine

class MenuApiService: MenuService {
    
    
    func getMenu() -> AnyPublisher<[CategoryDTO], HttpServiceError> {
        let params: [String:Any] = ["restaurant_id": 1]
        let url = EndPoints.BaseURL + EndPoints.HomeMenu
        return HttpService.Get(decodingType: BaseResponse<[CategoryDTO]>.self, urlString: url, params: params)
            .tryMap(extractMenu)
            .mapError({ error -> HttpServiceError in
                HttpServiceError.map(error)
            })
            .eraseToAnyPublisher()
    }
    
    func extractMenu(remote: BaseResponse<[CategoryDTO]>) throws -> [CategoryDTO]  {
        if remote.status && remote.data != nil  {
            return remote.data!
        }
        throw HttpServiceError.badResponse
    }
    
}
