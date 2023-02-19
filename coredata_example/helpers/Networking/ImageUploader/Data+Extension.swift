//
//  Data+Extension.swift
//  LooklokServices
//
//  Created by Yousef on 5/13/21.
//

import Foundation


extension Data {
    static func jsonObject(forResource file: String) -> Data? {
        
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            print("Failed to locate \(file) in bundle.")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    // used while uploading image
    public mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    func base64EncodedString() -> String {
        return self.base64EncodedString(options: .lineLength64Characters)
    }
    
}
