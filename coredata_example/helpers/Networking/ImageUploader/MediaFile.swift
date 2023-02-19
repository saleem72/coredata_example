//
//  HttpServiceModels.swift
//  Packages
//
//  Created by Yousef on 11/15/20.
//  Copyright © 2020 testy. All rights reserved.
//

import UIKit

enum MimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case video = "video/mp4"
    case subtitle = "video/subtitle"
    
    var extention: String {
        switch self {
            
        case .jpeg:
            return "jpeg"
        case .png:
            return "png"
        case .video:
            return "mp4"
        case .subtitle:
            return "srt"
        }
    }
}

struct MediaFile {
    let key: String
    let filename: String
    let data: Data
    let mimeType: MimeType
    
    init?(withImage image: UIImage, forKey key: String, mimeType: MimeType = .jpeg) {
        self.key = key
        self.mimeType = mimeType
        self.filename = "\(self.key).\(self.mimeType.extention)"
        
        guard let data = image.jpegData(compressionQuality: 0.4) else { return nil }
        self.data = data
    }
    
    init?(withURL urlString: String, forKey key: String, mimeType: MimeType = .video) {
        self.key = key
        self.mimeType = mimeType
        self.filename = "\(self.key).\(self.mimeType.extention)"
        guard let data = Self.getURLData(for: urlString) else { return nil }
        self.data = data
    }
    
    private static func getURLData(for urlString: String) -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return nil }
        return data
    }
    
    var type: String {
        return self.mimeType.rawValue
    }
    
    var base64EncodedString: String {
        return data.base64EncodedString(options: .lineLength64Characters)
    }
    
}
