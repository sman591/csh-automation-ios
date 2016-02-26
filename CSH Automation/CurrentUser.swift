//
//  CurrentUser.swift
//  CSH Automation
//
//  Created by Stuart Olivera on 2/25/16.
//  Copyright © 2016 Stuart Olivera. All rights reserved.
//


import Foundation
import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON

class CurrentUser: NSObject {
    
    class var sharedInstance : CurrentUser {
        struct Static {
            static let instance : CurrentUser = CurrentUser()
        }
        return Static.instance
    }
    
    var uid: String
    var updatedAt: NSDate
    
    init(uid: String = "") {
        self.uid = uid
        self.updatedAt = NSDate()
        CurrentUser.updateUser()
    }
    
    class func isLoggedIn() -> Bool {
        return AuthenticationManager.keyIsValid()
    }
    
    class func logout() {
        AuthenticationManager.invalidateKey()
    }
    
    class func setApiKey(apiKey: String) {
        AuthenticationManager.apiKey = apiKey
    }
    
    class func getApiKey() -> String? {
        return AuthenticationManager.apiKey
    }
    
    class func updateUser() {
        if let apiKey = CurrentUser.getApiKey() {
            AutomationApi.verifyApiKey(apiKey, completion: { data in
                self.sharedInstance.uid = data["uid"].stringValue
                self.sharedInstance.updatedAt = NSDate()
            })
        }
    }
    
}
