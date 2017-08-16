//
//  SecureRestClient.swift
//  ellactron
//
//  Created by admin on 2017-08-14.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class SecureURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {
    static var siteToken : String?
    
    
    public struct Const {
        static let keyPassphase = "pa55w0rd"
        static let keyFile = "ios"
        static let keyFileType = "p12"
        
        static let InterceptorURL = ApplicationConfiguration.getServiceHostname()!
        static let HandledKEy = "SecureURLProtocol"
    }
    
    private var dataTask: URLSessionDataTask?
    var afManager:Alamofire.SessionManager
    
    override init(request: URLRequest,
         cachedResponse: CachedURLResponse?,
         client: URLProtocolClient?) {
        
        let cert = PKCS12.init(mainBundleResource: Const.keyFile, resourceType: Const.keyFileType, password: Const.keyPassphase);
        
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: cert.secCertificatesRef,
            validateCertificateChain: true,
            validateHost: false
        )
        
        let serverTrustPolicies: [String: ServerTrustPolicy]  = [
            ApplicationConfiguration.getServiceHostname()!: serverTrustPolicy
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
        
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    // MARK: NSURLProtocol
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url?.absoluteString, url.contains(Const.InterceptorURL) else {
            return false
        }
        
        if (URLProtocol.property(forKey: Const.HandledKEy, in: request as URLRequest) != nil) {
            return false
        }
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let mutableRequest =  NSMutableURLRequest.init(
            url: self.request.url!,
            cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy,
            timeoutInterval: 240.0)//self.request as! NSMutableURLRequest
        
        // Prevent this protocol has been involved multiple times.
        URLProtocol.setProperty("true", forKey: Const.HandledKEy, in: mutableRequest)
        
        //Add Authorization Token
        if let token = SecureURLProtocol.siteToken {
            let valueString = "Bearer " + token
            mutableRequest.setValue(valueString, forHTTPHeaderField: "Authorization")
        }
        //print(mutableRequest.allHTTPHeaderFields ?? "")
        
        let session = afManager.session
        self.dataTask = session.dataTask(
            with:request,
            completionHandler: {
                [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    strongSelf.client?.urlProtocol(strongSelf, didFailWithError: error)
                    return
                }
                
                strongSelf.client?.urlProtocol(strongSelf, didReceive: response!, cacheStoragePolicy: .allowed)
                strongSelf.client?.urlProtocol(strongSelf, didLoad: data!)
                strongSelf.client?.urlProtocolDidFinishLoading(strongSelf)
        })
        
        self.dataTask!.resume()
    }
    
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask       = nil
    }
    
    // MARK: NSURLSessionDataDelegate
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data as Data)
    }
    
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest,
                           completionHandler: @escaping (URLRequest?) -> Void) {
        client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    }
    
    // MARK: NSURLSessionTaskDelegate
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if error != nil { //&& error.code != NSURLErrorCancelled {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

}
