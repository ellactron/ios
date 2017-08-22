//
//  ApplicationConfiguration.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class ApplicationConfiguration: NSObject {
    static let servicePropertiesPath:String = Bundle.main.path(forResource:"service", ofType: "plist")!
    
    public static func getServiceHostname() -> String {
        let serviceTable = NSDictionary(contentsOfFile: servicePropertiesPath)!
        return serviceTable.object(forKey: "hostname") as! String
    }
    
    public struct Cons {
        static let UserServiceName = "UserService"
        static let UIServiceName = "UIService"
    }
    
    static let serviceMap : [String: ServiceSchema] = [
        Cons.UserServiceName: ServiceSchema(),
        Cons.UIServiceName: ServiceSchema(schema: "http", hostname: ApplicationConfiguration.getServiceHostname(), port: 8080, requestClientCert: false, requestAuth: false)
    ]
    
    static func getServiceBasicUrl (serviceName:String) -> String? {
        if let serviceSchema = serviceMap[serviceName] {
            return serviceSchema.schema + "://"
                + serviceSchema.hostname + ":" + String(serviceSchema.port)
        }
        return nil
    }
}
