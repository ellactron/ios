//
//  Exceptions.swift
//  ellactron
//
//  Created by admin on 2017-07-31.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import Foundation
enum Exceptions : Error {
    case InvalidUrlException(url: String)
    case InvalidJsonFormatException(_ : Data)
}
