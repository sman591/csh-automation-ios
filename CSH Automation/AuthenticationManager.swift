//
//  AuthenticationManager.swift
//  CSH Automation
//
//  Created by Stuart Olivera on 2/25/16.
//  Copyright © 2016 Stuart Olivera. All rights reserved.
//

//
//  AuthenticationManager.swift
//  CSH Drink
//
//  Created by Stuart Olivera on 2/4/15.
//  Copyright (c) 2015 Stuart Olivera. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON

class AuthenticationManager: NSObject {
    
    private struct Constants {
        static let keychain = Keychain(service: "edu.rit.csh.automation")
        static let apiKey = "api_key"
    }
    
    class var apiKey: String? {
        get {
            return Constants.keychain[Constants.apiKey]
        }
        set {
            Constants.keychain[Constants.apiKey] = newValue
        }
    }
    
    class func invalidateKey() {
        self.apiKey = nil
    }
    
    class func keyIsValid() -> Bool {
        return self.apiKey != nil
    }
    
}
