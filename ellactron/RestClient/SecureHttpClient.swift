//
//  RestClient.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Alamofire

class SecureHttpClient: NSObject {
    var afManager:SessionManager
    
    override init() {
        let cert = PKCS12.init(mainBundleResource: "ios", resourceType: "p12", password: "pa55w0rd");
        
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: cert.secCertificatesRef,
            validateCertificateChain: true,
            validateHost: false
        )

        let serverTrustPolicies: [String: ServerTrustPolicy]  = [
            ApplicationConfiguration.getServiceHostname(): serverTrustPolicy
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

    func request(method: String!,
                 uri: String,
                 onCompletion: @escaping (_ result: String?) -> Void,
                 errorHandler: @escaping (_ result: String) -> Void) throws{
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let urlPath = URL(string: uri) else {
            throw Exceptions.InvalidUrlException(url: uri)
        }

        var request = URLRequest(url:urlPath)
        request.httpMethod = method
        
        //Add Authorization Token
        //let valueString = "Bearer "
        //request.setValue(valueString, forHTTPHeaderField: "Authorization")
        
        let session = afManager.session
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(
            with:request,
            completionHandler: {
                data, response, error -> Void in
                
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
        })
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
