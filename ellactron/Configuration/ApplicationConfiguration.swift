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

    static var token: String?
    
    static let serviceMap : [String: ServiceSchema] = [
        Cons.UserServiceName: ServiceSchema(schema: "https", hostname: ApplicationConfiguration.getServiceHostname(), port: 8443, requestClientCert: false, requestAuth: false),
        Cons.UIServiceName: ServiceSchema(schema: "https", hostname: ApplicationConfiguration.getServiceHostname(), port: 8443, requestClientCert: false, requestAuth: false)
    ]
    
    static func getServiceBasicUrl (serviceName:String) -> String? {
        if let serviceSchema = serviceMap[serviceName] {
            return serviceSchema.schema + "://"
                + serviceSchema.hostname + ":" + String(serviceSchema.port)
        }
        return nil
    }
}
