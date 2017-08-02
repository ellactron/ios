//
//  RestClient.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class RestClient: NSObject {
    func get(uri: String, onCompletion: @escaping (_ json: Any?, _ error: Error?) -> Void) throws{
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let urlPath = URL(string: uri) else {
            throw Exceptions.InvalidUrlException(url: uri)
        }
        
        let request = URLRequest(url:urlPath)
        let session = URLSession.shared
        
        let task = session.dataTask(
            with:request,
            completionHandler: {
                data, response, error -> Void in
                
                if error != nil {
                    print(error!.localizedDescription)
                    onCompletion(nil, error)
                }
                else {
                    do {
                        guard let jsonData = try JSONSerialization.jsonObject(with: data as Data!, options: []) as? [String: Any] else {
                            throw Exceptions.InvalidJsonFormatException(data!)
                        }
                        onCompletion(jsonData, error)
                    } catch let err {
                        print(err)
                        onCompletion(nil, err)
                    }
                }
                semaphore.signal()
        })
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
