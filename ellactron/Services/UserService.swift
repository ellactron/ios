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
                  response: @escaping (String?) -> Void,
                  error: @escaping (String) -> Void) {
        let params = ["username":username,
                      "password":password]
        
        do {
            try post(url: getUserServiceUrl() + "/register",
                     data: params,
                     onCompletion: response,
                     errorHandler: error)
        }
        catch let err {
            print(String(describing: err))
        }
    }
}
