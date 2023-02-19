//
//  ImageUploader.swift
//  TestMyCode
//
//  Created by Yousef on 1/1/21.
//

import UIKit




public protocol ImageUploaderDelegate {
    func doneWithSuccess<Datatype>(data: Datatype)
    func doneWithError(error: Error)
    func madeProgress(progress: Float)
}

let lineBreak = "\r\n"
let clientID = "45903254233d04e"

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
    case acceptLanguage = "Accept-Language"
    case contentTypeValue = "Keep-Alive"
    case connection = "Connection"
    
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
    
}

class ImageUploader: NSObject {
    
    
    //MARK: - Public Properties
    public var delegate: ImageUploaderDelegate?
    public var uploadVideoTask: URLSessionUploadTask? = nil
    
    //MARK: - Private funcs
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func createDataBody(withParameters params: [String : String]?, media: [MediaFile]?, boundary: String) -> Data {
        
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType.rawValue + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
       
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    
    
    
   
    
    
    //MARK: - Public Funcs
    
    //MARK: Upload image using URLSession
    func uploadImage<ResultData: Decodable>(urlString: String, key: String, media: MediaFile, parameters: [String : String]? = nil,
                     complition: @escaping (Result<ResultData, Error>) -> Void) {
        
        print(#function, urlString)
//        if NetworkMonitor.shared.connectionType != .wifi  {
//            complition(.failure(ImageUploaderError.noNet))
//            return
//        }
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let base64Image = media.base64EncodedString

        // Update
        
        var newParams: [String:String]
        if parameters != nil {
            newParams = parameters!
            newParams[key] = base64Image
        } else {
            newParams = [
                key: base64Image
            ]
        }
        
        let boundary = generateBoundary()
        
        print(#file, #function, "token: \(AuthManager.shared.token)")
        //MARK: Headers
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderField.connection.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let dataBody = createDataBody(withParameters: newParams, media: [media], boundary: boundary)
        request.httpBody = dataBody
 
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        session.uploadTask(with: request, from: dataBody) { data, respose, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                guard let data = data else {
                    complition(.failure(ImageUploaderError.noData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    print(error.localizedDescription)
                }
                
                do {
                    
                    
                    let json = try JSONDecoder().decode(ResultData.self, from: data)
                    complition(.success(json))
                }
                catch let decodingError {
                    complition(.failure(decodingError))
                }
                
            }
            
        }.resume()
    }
    
    private func getImage(inputImageURL: String) -> UIImage? {
        guard let url = URL(string: inputImageURL) else {
            print(#function, "Can't create URL")
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            print(#function, "Can't create Data")
            return nil
        }
        let image = UIImage(data: data)
        return image
    }
    
    private func createMedia(url: String, key: String) -> MediaFile? {
        if let image = getImage(inputImageURL: url) {
            return MediaFile(withImage: image, forKey: key)
        }
        
        return nil
    }
    
    private func createImagesArray(data: [ImageInfo]) -> [MediaFile] {
        var images = [MediaFile]()
        
        for info in data {
            if let image = createMedia(url: info.url, key: info.key) { 
                images.append(image)
            }
        }
        
        return images
    }
   
    func uploadMultiImage<ResultData: Decodable>(urlString: String, imagesInfo: [ImageInfo], parameters: [String : String]? = nil,
                     complition: @escaping (Result<ResultData, Error>) -> Void) {
        
        print(#function, urlString)
//        if NetworkMonitor.shared.connectionType != .wifi  {
//            complition(.failure(ImageUploaderError.noNet))
//            return
//        }
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let images = createImagesArray(data: imagesInfo)

        // Update
        var newParams = [String:String]()
        if parameters != nil {
            newParams = parameters!
        }
        
        for image in images {
            newParams[image.key] = image.base64EncodedString
        }
        
        let boundary = generateBoundary()
        
        print(#file, #function, "token: \(AuthManager.shared.token)")
        //MARK: Headers
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderField.connection.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let dataBody = createDataBody(withParameters: newParams, media: images, boundary: boundary)
        request.httpBody = dataBody
 
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        session.uploadTask(with: request, from: dataBody) { data, respose, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                guard let data = data else {
                    complition(.failure(ImageUploaderError.noData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    print(error.localizedDescription)
                }
                
                do {
                    
                    
                    let json = try JSONDecoder().decode(ResultData.self, from: data)
                    complition(.success(json))
                }
                catch let decodingError {
                    complition(.failure(decodingError))
                }
                
            }
            
        }.resume()
    }
    
    func uploadMultiImage<ResultData: Decodable>(urlString: String, images: [MediaFile], parameters: [String : String]? = nil,
                     complition: @escaping (Result<ResultData, Error>) -> Void) {
        
        print(#function, urlString)
//        if NetworkMonitor.shared.connectionType != .wifi  {
//            complition(.failure(ImageUploaderError.noNet))
//            return
//        }
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
//        let images = createImagesArray(data: imagesInfo)

        // Update
        var newParams = [String:String]()
        if parameters != nil {
            newParams = parameters!
        }
        
        for image in images {
            newParams[image.key] = image.base64EncodedString
        }
        
        let boundary = generateBoundary()
        
        print(#file, #function, "token: \(AuthManager.shared.token)")
        //MARK: Headers
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderField.connection.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        let dataBody = createDataBody(withParameters: newParams, media: images, boundary: boundary)
        request.httpBody = dataBody
 
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        session.uploadTask(with: request, from: dataBody) { data, respose, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                guard let data = data else {
                    complition(.failure(ImageUploaderError.noData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    print(error.localizedDescription)
                }
                
                do {
                    
                    
                    let json = try JSONDecoder().decode(ResultData.self, from: data)
                    complition(.success(json))
                }
                catch let decodingError {
                    complition(.failure(decodingError))
                }
                
            }
            
        }.resume()
    }
    
    //MARK: Upload array of images using URLSession
    func uploadMediaArray<ResultData: Decodable>(method: String, urlPath: String, key: String, params: [String : String], images: [MediaFile],
                                          complition: @escaping (Result<ResultData, Error>) -> Void) {
        
       
        
        guard let url = URL(string: urlPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod =  "POST" // method
        
        var newParams: [String:String]
        newParams = params
        
        let boundary = generateBoundary()
        
        
        //MARK: Headers
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // \(UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.storedToken) ?? "")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderField.connection.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        //MARK: Body
        var body = Data()
        
        for (key, value) in newParams {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
        
        if images.count > 0 {
            for (index, photo) in images.enumerated() {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)[\(index)]\"; filename=\"image\(index)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType.rawValue + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        request.httpBody = body
  
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        session.uploadTask(with: request, from: body) { data, respose, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                guard let data = data else {
                    complition(.failure(ImageUploaderError.noData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                } catch {
                    print(error.localizedDescription)
                }
                
                
                let decoder = JSONDecoder()
                do {
                    
                    
                    let json = try decoder.decode(ResultData.self, from: data)
                    complition(.success(json))
                }
                catch let decodingError {
                    
                    if let metaResponse = try? decoder.decode(ApiCommonResponse.self, from: data) {
                        
                        // CombineHttpError
                        // URLSessionHttpError.error400(message: metaResponse.meta.message, statusCode: metaResponse.meta.statusNumber)
                        complition(.failure(HttpServiceError.badRequest(metaResponse.meta.message ?? "Unknown Error")))
                        return
                    }
                    complition(.failure(decodingError))
                }
                
            }
            
        }.resume()
    }
    
    
    
    
    
    
    
    
     
}

extension ImageUploader {
    enum EndPoints {
        static var uploadVideo = "api/uploadVideo"
    }
}



//MARK: - extension URLSessionDelegate to track progress in uploading and downloading tasks
extension ImageUploader: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.doneWithError(error: error)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
//        print("\(Int(progress * 100)) %")
        DispatchQueue.main.async { [weak self] in
            
            self?.delegate?.madeProgress(progress: progress)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        DispatchQueue.main.async { [weak self] in
            print("**************")
            if let aa = response as? HTTPURLResponse {
                print("Status Code: \(aa.statusCode)")
                print("URL: \(aa.url?.absoluteString ?? "no url")")
                
                self?.delegate?.doneWithSuccess(data: aa)
            } else {
                self?.delegate?.doneWithSuccess(data: HTTPURLResponse())
            }
            print("**************")
        }
    }
}

//TODO: Activate this extension to use it for uploading movies

extension ImageUploader {
    
//    private func videoParams(media: ApiUploadVideoModel) -> [String:String] {
//
//        var params: [String:String] = [:]
//        params["category_id"] =  "10" //"\(media.categoryId)"
//        params["orientation_id"] = "1"  // "\(media.orientationId)"
//        params["mime_type"] = "video/mp4"  // "\(media.mimeType)"
//        params["title"] = "\(media.title)"
//        params["description"] = "\(media.description)"
//        return params
//    }
    
    private func createVideoUploadBody(withParameters params: [String : String], video: MediaFile, boundary: String) -> Data {
        
        var body = Data()
        
        for (key, value) in params {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }
        
        let videoKey = video.key
        let videoFileName = video.filename
        let videoData = video.data
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(videoKey)\"; filename=\"\(videoFileName)\"\(lineBreak)")
        body.append("Content-Type: \("mp4" + lineBreak + lineBreak)")
        body.append(videoData)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    func createVideoUploadRequest(url: URL, media: MediaFile, parameters: [String:String]?) -> URLRequest? {
        
        
        var request = URLRequest(url: url)
        request.httpMethod =  "POST" // method
        
        var params: [String : String]
        if let userParam = parameters {
            params = userParam
        } else {
            params = [String:String]()
        }
        
        let boundary = generateBoundary()
        
        /*
         request.addValue("application/json", forHTTPHeaderField: "Content-type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
         request.addValue("\(LocalizationManager.shared.currentLanguage.rawValue)", forHTTPHeaderField: "lang")
         */
        //MARK: Headers
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderField.connection.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.addValue("\(LocalizationManager.shared.currentLanguage.rawValue)", forHTTPHeaderField: "lang")
        
        let dataBody = createVideoUploadBody(withParameters: params, video: media, boundary: boundary)
        request.httpBody = dataBody
        return request
    }
    
    func uploadVideo<T: Decodable>(urlString: String, media: MediaFile, parameters: [String:String]? = nil, decodingType: T.Type, complition: @escaping (_ result: Result<T, Error>) -> Void) {
        
        
        
        guard let url = URL(string: urlString) else {
            complition(.failure(ImageUploaderError.badURL(urlString)))
            return
        }
        
        guard let request = createVideoUploadRequest(url: url, media: media, parameters: parameters) else {
            complition(.failure(ImageUploaderError.badMovie))
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        uploadVideoTask = session.uploadTask(with: request, from: request.httpBody) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    complition(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    complition(.failure(ImageUploaderError.badResponse))
                    return
                }
                
                if response.statusCode == 500 {
                    complition(.failure(ImageUploaderError.badResponse))
                    return
                }
                
                guard let data = data else {
                    complition(.failure(ImageUploaderError.noData))
                    return
                }
                
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
//                } catch {
//                    print(error.localizedDescription)
//                }
                
                do {
                    
                    let json = try JSONDecoder().decode(ApiGenericResponse<T>.self, from: data)
                    if json.meta.status {
                        if let result = json.data {
                        complition(.success(result))
                        } else {
                            complition(.failure(ImageUploaderError.error400(model: json.meta.message ?? "unknwn error")))
                        }
                    } else {
                        let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        print(result ?? "Can't read json from response")
                        complition(.failure(ImageUploaderError.error400(model: json.meta.message ?? "unknwn error")))
                    }
                    
                }
                catch let decodingError {
                    let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result ?? "Can't read json from response")
                    
                    complition(.failure(decodingError))
                }
                
            }
            
        }
        uploadVideoTask?.resume()
        
    }
}


//MARK: - ImageUploaderError
enum ImageUploaderError: Error {
    case error400(model: String)
    case noData
    case noNet
    case badMovie
    case badURL(String)
    case badResponse
    case serverError
    case badImage
}

extension ImageUploaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error400(let message): return NSLocalizedString(message, comment: "")
        case .noData: return NSLocalizedString("Request done but there was no data back", comment: "")
        case .noNet: return NSLocalizedString("ImageUploaderError There is no active itenernt connection on your device\(lineBreak)Please try agian later", comment: "")
        case .badMovie: return NSLocalizedString("Couldn't read the video correctly\nplease choose another file", comment: "")
        case .badURL(let path): return NSLocalizedString("it is bad URL \(path)", comment: "")
        case .badResponse: return NSLocalizedString("some thing bad happend please try again later Response", comment: "")
        case .serverError: return NSLocalizedString("Server is busy right now\nPlease try again later", comment: "")
        case .badImage: return NSLocalizedString("Can't retrive image", comment: "")
        }
    }
}



/*
   //MARK: Upload image using alamofire
   func alamofireUploadImage<ResultData: Decodable>(urlString: String, media: MediaFile,
                                                    complition: @escaping (Result<ResultData, Error>) -> Void) {

       
       if NetworkMonitor.shared.connectionType != .wifi  {
           complition(.failure(ImageUploaderError.noNet))
           return
       }
       
//         let imageData = image.pngData()
       let base64Image = media.base64EncodedString

       
       
       let headerS: HTTPHeaders = [
           "Authorization" : "Client-ID 45903254233d04e",
           HTTPHeaderField.connection.rawValue : HTTPHeaderField.contentTypeValue.rawValue
       ]

       let parameters = [
           "image": base64Image
       ]
       
       AF.upload(multipartFormData: { (multipartFormData) in

           for (key, value) in parameters {
               multipartFormData.append((value.data(using: .utf8))!, withName: key)
           }
           
       }, to: urlString, method: .post, headers: headerS)
       .uploadProgress { [weak self] (progress) in
           self?.delegate?.madeProgress(progress: Float(progress.fractionCompleted))
       }
       
//        .responseJSON { response in
//            print(response)
//        }
       
       .responseDecodable(of: ResultData.self) { [weak self] response in
           switch response.result {
               
           case .success(let data):
               complition(.success(data))
               self?.delegate?.doneWithSuccess(data: data)
               
           case .failure(let error):
               self?.delegate?.doneWithError(error: error)
           }
       }
        
    }
   */
