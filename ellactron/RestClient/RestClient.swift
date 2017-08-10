//
//  RestClient.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation
import Alamofire

class RestClient: NSObject {
    
    func getCertificates() -> [SecCertificate] {
        let localCertificate = ApplicationConfiguration.getCertificates().data(using: .utf8)
        return [SecCertificateCreateWithData(nil, localCertificate! as CFData)!]
    }
    
    override init() {
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: getCertificates(),
            validateCertificateChain: true,
            validateHost: false
        )
        
        let serverTrustPolicies = [ApplicationConfiguration.getServiceHostname(): serverTrustPolicy]
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        // Configure session manager with trust policy
        let afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: serverTrustPolicyManager
        )
    }
    
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
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(String(describing: response))")
                        }
                        
                        if let data = data {
                            let responseString = String(data: data, encoding: .utf8)
                            print("responseString = \(String(describing: responseString))")
                        
                            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                                throw Exceptions.InvalidJsonFormatException(data)
                            }
                            onCompletion(jsonData, error)
                        }
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
