//
//  Bundle+Extension.swift
//  ArchitectureTestingApp
//
//  Created by Yousef on 10/26/21.
//

import Foundation

extension Bundle {
    func ObjectFromJson<T: Decodable>(type: T.Type,fileName: String, complition: (Result<T, Error>) -> Void) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "") else {
            complition(.failure(BundleDecodingError.fileNotFound(fileName)))
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            complition(.failure(BundleDecodingError.failToGetData))
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            complition(.failure(BundleDecodingError.failToDecode))
            return
        }
        
        complition(.success(result))
        
    }
    
    enum BundleDecodingError: Error, LocalizedError {
        case fileNotFound(String), failToGetData, failToDecode
        
        var errorDescription: String? {
            switch self {
            
            
            case .fileNotFound(let fileName):
                return "Can't find file: \(fileName)"
            case .failToGetData:
                return "Can't get data from file"
            case .failToDecode:
                return "Some of your data are corrpted"
            }
        }
    }
}
