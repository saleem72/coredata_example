//
//  HttpService.swift
//  PlaygroundForTesting
//
//  Created by Yousef on 8/16/21.
//

import Foundation
import SwiftUI
import Combine


enum HttpServiceError: Error, LocalizedError {
    case noNet
    case statusCode
    case decoding
    case invalidURL(String)
    case other(Error)
    case badResponse
    case badRequest(String)
    case emptyData
    
    static func map(_ error: Error) -> HttpServiceError {
        return (error as? HttpServiceError) ?? .other(error)
    }
    
    var errorDescription: String? {
        switch self {
        case .noNet:
            return "Check you internet connection"
        case .statusCode:
            return "Server Error"
        case .decoding:
            return "Some of your data is correpted"
        case .invalidURL(let url):
            return "Bad URL: \(url)"
        case .other(let error):
            return error.localizedDescription
        case .badResponse:
            return "Bas Response"
        case .badRequest(let message):
            return message
        case .emptyData:
            return "return data is not valid"
        }
    }
}




class HttpService {
    
    static private func mapResponse(data: Data, response: URLResponse) throws -> Data {
        guard
            let _ = response as? HTTPURLResponse
        else {
            throw HttpServiceError.badResponse
        }
        
        return data
    }
    
    
    
    private static func handleResponse<T: Decodable>(decodingType: T.Type, request: URLRequest, printResult: Bool = false) ->  AnyPublisher<T, HttpServiceError>{
       
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ response -> Data in
                guard
                    let _ = response.response as? HTTPURLResponse
                else {
                    throw HttpServiceError.badResponse
                }
                
                return response.data
            })
            .tryMap({ (response) -> T in
                
                let result = handleData(decodingType: decodingType, response: response, printResult: printResult)
                switch result {

                case .success(let data):
                    return data
                case .failure(let error):
                    throw error
                }
            })
            .mapError { HttpServiceError.map($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
   
    
     /// create url from string and add query parameters to this url
    static private func createURL(url: String, queryParam: [String : Any]?) -> URL? {
        guard var urlComps = URLComponents(string: url) else {
            
            return nil
        }
        
        if let queryParam = queryParam {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in queryParam {
                let queryItem = URLQueryItem(name: key, value: String(describing: value))
                queryItems.append(queryItem)
            }
         
            urlComps.queryItems = queryItems
        }
        
        return urlComps.url
    }
    
    static private func handleData<T: Decodable>(decodingType: T.Type, response: Data, printResult: Bool = false) -> Result<T, Error> {
        
        if printResult {
            doPrintResult(response: response)
        }
        
        if let result = try? JSONDecoder().decode(T.self, from: response) {
            return .success(result)
        } else {
            doPrintResult(response: response)
            return .failure(HttpServiceError.decoding)
        }
    }
    
    static func doPrintResult(response: Data) {
        if let stringResponse = try? JSONSerialization.jsonObject(with: response, options: .allowFragments) {
            print("🔥 Error:")
            print("Response", stringResponse)
            print("*************************************")
        }
    }
    
}


//MARK: - General REST Calls
extension HttpService {
    //MARK: Get
    static func Get<T: Decodable>(
        decodingType: T.Type,
        urlString: String,
        params: [String : Any]? = nil
    ) -> AnyPublisher<T, HttpServiceError>  {
       
//        guard Reachability.isConnectedToNetwork() else {
//            return Fail(error: HttpServiceError.noNet)
//                .eraseToAnyPublisher()
//        }
        
        guard let url = createURL(url: urlString, queryParam: params) else {
            return Fail(error: HttpServiceError.invalidURL(urlString))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        // Set request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
//        request.addValue("\(LocalizationManager.shared.currentLanguage.rawValue)", forHTTPHeaderField: "lang")
        
        return handleResponse(decodingType: decodingType, request: request)
            
//            .eraseToAnyPublisher()
            
    }
    
    //MARK: Post
    static func Post<T: Decodable, U: Encodable>(
        decodingType: T.Type,
        body: U,
        urlString: String,
        params: [String : Any]? = nil,
        printResult: Bool = false
    ) -> AnyPublisher<T, HttpServiceError> {
        guard let url = createURL(url: urlString, queryParam: params) else {
            return Fail(error: HttpServiceError.invalidURL(urlString))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        // Set request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
//        request.addValue("\(LocalizationManager.shared.currentLanguage.rawValue)", forHTTPHeaderField: "lang")
        
        // Set request body
        let tempBody = try? JSONEncoder().encode(body)
        request.httpBody = tempBody
        
        return handleResponse(decodingType: decodingType, request: request, printResult: printResult)
    }
    
    //MARK: Put
    static func Put<T: Decodable, U: Encodable>(
        decodingType: T.Type,
        body: U,
        urlString: String,
        params: [String : Any]? = nil
    ) -> AnyPublisher<T, HttpServiceError> {
        guard let url = createURL(url: urlString, queryParam: params) else {
            return Fail(error: HttpServiceError.invalidURL(urlString))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        
        // Set request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        // Set request body
        let tempBody = try? JSONEncoder().encode(body)
        request.httpBody = tempBody
        
        return handleResponse(decodingType: decodingType, request: request)
    }
    
    
    static func unFollowedPost<T: Encodable>(URL urlString: String, body: T? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        var request = createRequest(url: url, method: .post)
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        URLSession.shared.dataTask(with: request) { (data, respopnse, error) in
            
        }.resume()
        
        URLSession.shared.dataTask(with: url).resume()
        
    }
    
    static func unFollowedGet(URL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let request = createRequest(url: url, method: .get)
        
        URLSession.shared.dataTask(with: request) { (data, respopnse, error) in
            
        }.resume()
        
        URLSession.shared.dataTask(with: url).resume()
        
    }
    
    static private func createRequest(url: URL, method: RequestMethod) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        // Set request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
//        request.addValue("\(LocalizationManager.shared.currentLanguage.rawValue)", forHTTPHeaderField: "lang")
        
        return request
    }
    
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
}


