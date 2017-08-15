//
//  HttpClient.swift
//  ellactron
//
//  Created by admin on 2017-08-14.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class RestClient: NSObject {
    override init() {
        URLProtocol.registerClass(SecureURLProtocol.self)
    }
    
    public func request(method: String, url: String, onCompletion: @escaping (_ result: String?) -> Void, errorHandler: @escaping (_ result: String) -> Void) throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        // MARK: Request data
        guard let urlPath = URL(string: url) else {
            throw Exceptions.InvalidUrlException(url: url)
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = method
        
        // MARK: Headers
        //request.setValue("", forHTTPHeaderField: "")
        
        let session = URLSession.shared
        session.dataTask(with: urlPath, completionHandler: {
            (data, response, error) in
            guard error == nil else {              // check for fundamental networking error
                errorHandler(String(describing: error))
                return
            }

            if let httpStatus = response as? HTTPURLResponse {      // check for http errors
                switch httpStatus.statusCode {
                case 200 ... 299:
                    if let data = data {
                        /*guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            throw Exceptions.InvalidJsonFormatException(data)
                         }*/
                        onCompletion(String(data: data, encoding: .utf8))
                    }
                    else {
                        // Print HTTP response header detail
                        print(String(describing: response))
                    }
                default:
                    print("statusCode should be within 200 to 299, but is \(httpStatus.statusCode)")
                    errorHandler(String(describing: response))
                }
            }

            semaphore.signal()
        }).resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
