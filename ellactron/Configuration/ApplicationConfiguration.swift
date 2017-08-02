//
//  ApplicationConfiguration.swift
//  ellactron
//
//  Created by admin on 2017-07-27.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class ApplicationConfiguration: NSObject {
    public static func getServiceHostname() -> String? {
        let path:String = Bundle.main.path(forResource:"service", ofType: "plist")!
        let serviceTable = NSDictionary(contentsOfFile: path)
        guard let hostname = serviceTable!.object(forKey: "hostname") else {
            return nil
        }

        return hostname as? String
    }
}
