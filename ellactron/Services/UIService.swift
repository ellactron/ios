//
//  UIService.swift
//  ellactron
//
//  Created by Ji Wang on 2017-09-03.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class UIService : RestClient {
    
    static func getMainPage() -> String {
        let serviceBaseUrl = ApplicationConfiguration.getServiceBasicUrl(serviceName: ApplicationConfiguration.Cons.UIServiceName)!
        
        return serviceBaseUrl + "/static/main.html";
    }
}
