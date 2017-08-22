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
    
    func request(method: String,
                 url: String,
                 params: [String:String]?,
                 contentType: String?,
                 accept: String?,
                 onCompletion: @escaping (_ result: String?) -> Void,
                 errorHandler: @escaping (_ result: String) -> Void) throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        // MARK: Request data
        guard let urlPath = URL(string: url) else {
            throw Exceptions.InvalidUrlException(url: url)
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = method
        
        // MARK: Headers
        if let postString = getPostString(params: params) {
            request.httpBody = postString.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        else if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        if let accept = accept {
            request.addValue(accept, forHTTPHeaderField: "Accept")
        }
        
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

    
    func getPostString(params:[String:String]? ) -> String? {
        if let params = params {
            var postString:String = ""
            for (name, value) in params {
                if "" != postString {
                    postString += "&"
                }
                postString.append(name + "=" + value)
            }
            return postString
        }
        return nil
    }
    
    
    func get(url:String,
             onCompletion: @escaping (_ result: String?) -> Void,
             errorHandler: @escaping (_ result: String) -> Void) throws {
        try request(method: "get",
                    url: url,
                    params: nil,
                    contentType: nil,
                    accept: "application/json",
                    onCompletion: onCompletion,
                    errorHandler: errorHandler)
    }
    
    
    func delete(url:String,
                onCompletion: @escaping (_ result: String?) -> Void,
                errorHandler: @escaping (_ result: String) -> Void) throws {
        try request(method: "delete",
                    url: url,
                    params: nil,
                    contentType: nil,
                    accept: "application/json",
                    onCompletion: onCompletion,
                    errorHandler: errorHandler)
    }
    
    
    func post(url:String,
              data:[String:String]?,
              onCompletion: @escaping (_ result: String?) -> Void,
              errorHandler: @escaping (_ result: String) -> Void) throws {
        try request(method: "delete",
                    url: url,
                    params: data,
                    contentType: nil,
                    accept: "application/json",
                    onCompletion: onCompletion,
                    errorHandler: errorHandler)
    }
    
    
    func put(url:String,
              data:[String:String]?,
              onCompletion: @escaping (_ result: String?) -> Void,
              errorHandler: @escaping (_ result: String) -> Void) throws {
        try request(method: "put",
                    url: url,
                    params: data,
                    contentType: nil,
                    accept: "application/json",
                    onCompletion: onCompletion,
                    errorHandler: errorHandler)
    }
}
