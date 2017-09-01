//
//  UserService.swift
//  ellactron
//
//  Created by admin on 2017-08-16.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class UserService : RestClient {
    func getUserServiceUrl() -> String {
        return ApplicationConfiguration.getServiceBasicUrl(serviceName: ApplicationConfiguration.Cons.UserServiceName)!
    }
    
    func getUIServiceUrl() -> String {
        return ApplicationConfiguration.getServiceBasicUrl(serviceName: ApplicationConfiguration.Cons.UIServiceName)!
    }
    
    func register(username:String,
                  password: String,
                  response: @escaping (Any?) -> Void,
                  error: @escaping (String) -> Void) {
        let params = ["username":username,
                      "password":password]
        
        do {
            try post(url: getUserServiceUrl() + "/register",
                    data: params,
                    onCompletion: {(html) -> Void in
                        do {
                            let json = try self.convertToJson(jsonString: html)
                            response(json)
                        }
                        catch let err {
                            error("Can't convert " + String(describing: html) + " to Json object")
                        }
                    },
                    errorHandler: error)
        }
        catch let err {
            print(String(describing: err))
        }
    }
    
    func getSiteToken(username:String,
                                   password:String,
                                   response: @escaping (Any?) -> Void,
                                   error: @escaping (String) -> Void) {
        let params = ["username":username,
                      "password":password]
        do {
            try post(url:getUserServiceUrl() + "/login/token",
                    data: params,
                    onCompletion: {(html) -> Void in
                        do {
                            let json = try self.convertToJson(jsonString: html)
                            response(json)
                        }
                        catch let err {
                            error("Can't convert " + String(describing: html) + " to Json object")
                        }
                    },
                    errorHandler: error)
        }
        catch let err {
            print(String(describing: err))
        }
    }
    
    func getSiteTokenByFacebookToken(facebookAccessToken:String,
                                     response: @escaping (Any?) -> Void,
                                     error: @escaping (String) -> Void) {
        do {
            try put(url: getUserServiceUrl() + "/login/facebook/accesstoken/" + facebookAccessToken,
                    data: nil,
                    onCompletion: {(html) -> Void in
                        do {
                            let json = try self.convertToJson(jsonString: html)
                            response(json)
                        }
                        catch let err {
                            error("Can't convert " + String(describing: html) + " to Json object")
                        }
                    },
                    errorHandler: error)
        }
        catch let err {
            print(String(describing: err))
            error(String(describing: err))
        }
    }
    
    func convertToJson(jsonString:Data?) throws -> Any? {
        if let jsonString = jsonString {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: jsonString, options: []) as? [String: Any]
                return jsonData
            }
            catch let err {
                print(String(describing: err))
                throw Exceptions.InvalidJsonFormatException(jsonString)
            }
        }

        return nil
    }
    
    
}
