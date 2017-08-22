//
//  ServiceSchema.swift
//  ellactron
//
//  Created by admin on 2017-08-16.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation

class ServiceSchema {
    init() {}
    
    init(schema : String, hostname: String, port: Int, requestClientCert: Bool, requestAuth: Bool) {
        self.schema = schema
        self.hostname = hostname
        self.port = port
        self.requestClientCert = requestClientCert
        self.requestAuth = requestAuth
    }
    
    var schema:String = "https"{
        willSet(schema) {
            self.schema = schema
        }
    }
    var hostname: String = ApplicationConfiguration.getServiceHostname() {
        willSet(hostname) {
            self.hostname = hostname
        }
    }
    var port:Int = 8443 {
        willSet(port) {
            self.port = port
        }
    }
    var requestClientCert: Bool = true {
        willSet(requestClientCert) {
            self.requestClientCert = requestClientCert
        }
    }
    var requestAuth: Bool = true {
        willSet(requestAuth) {
            self.requestAuth = requestAuth
        }
    }
}
