//
//  RestClient.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Alamofire

class RestClient: NSObject {
    var afManager:SessionManager
    let hostname = "www.ellactron.com"

    static func getCertificates() -> [SecCertificate]! {
        guard let localCertificate = ApplicationConfiguration.getCertificates().data(using: .utf8) else{
            return []
        }
        
        return [SecCertificateCreateWithData(nil, localCertificate as CFData)!]
    }
    
    override init() {
        let cert = PKCS12.init(mainBundleResource: "ios", resourceType: "p12", password: "pa55w0rd");
        
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: cert.secCertificatesRef,
            validateCertificateChain: true,
            validateHost: false
        )

        let serverTrustPolicies: [String: ServerTrustPolicy]  = [
            hostname: serverTrustPolicy
        ]
        
        /* Or:
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            hostname: .disableEvaluation
        ]
        */

        afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        afManager.delegate.sessionDidReceiveChallenge = { session, challenge in
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                return (URLSession.AuthChallengeDisposition.useCredential, cert.urlCredential());
            }
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!));
            }
            return (URLSession.AuthChallengeDisposition.performDefaultHandling, Optional.none);
        }
    }

    func get(uri: String, onCompletion: @escaping (_ json: Any?, _ error: Error?) -> Void) throws{
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let urlPath = URL(string: uri) else {
            throw Exceptions.InvalidUrlException(url: uri)
        }
        
        let request = URLRequest(url:urlPath)
        let session = afManager.session
        
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
