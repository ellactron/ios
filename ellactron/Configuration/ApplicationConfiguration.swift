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
    
    public static func getServiceHostname() -> String? {
        let serviceTable = NSDictionary(contentsOfFile: servicePropertiesPath)
        guard let hostname = serviceTable!.object(forKey: "hostname") else {
            return nil
        }

        return hostname as? String
    }
    
    static var siteToken : String?
}
