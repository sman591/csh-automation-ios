//
//  AutomationApi.swift
//  CSH Automation
//
//  Created by Stuart Olivera on 2/25/16.
//  Copyright © 2016 Stuart Olivera. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON
import Alamofire

class AutomationApi {
    
    typealias AutomationAPIFailure = (ErrorType, String?) -> Void
    typealias AutomationAPISuccess = JSON -> Void

    private struct Constants {
        static let sharedInstance = AutomationApi()
        static let baseURL = "http://control.csh.rit.edu:8080"
    }

    class func verifyApiKey(apiKey: String, completion: AutomationAPISuccess? = nil, failure: AutomationAPIFailure? = nil) {
        self.makeRequest(
            .POST,
            route: "user_api/verify",
            parameters: [
                "token": [
                    "id": apiKey
                ]
            ],
            completion: completion,
            failure: failure
        )
    }
    
    class func loungeProjectorGetStatus(completion: AutomationAPISuccess? = nil, failure: AutomationAPIFailure? = nil) {
        self.makeRequest(
            .POST,
            route: "lounge/projector",
            completion: completion,
            failure: failure
        )
    }
    
    class func loungeProjectorTogglePower(power: Bool, completion: AutomationAPISuccess? = nil, failure: AutomationAPIFailure? = nil) {
        self.makeRequest(
            .POST,
            route: "lounge/projector/power",
            parameters: [
                "power": [
                    "state": power
                ]
            ],
            completion: completion,
            failure: failure
        )
    }
    
    class func makeRequest(method: Alamofire.Method, route: String, parameters: [String: AnyObject]? = nil, completion: AutomationAPISuccess? = nil, failure: AutomationAPIFailure? = nil) {
        var fullParameters = parameters ?? [String: AnyObject]()
        if let apiKey = CurrentUser.getApiKey() {
            fullParameters["token"] = [
                "id": apiKey
            ]
        }
        Alamofire.request(
            method,
            Constants.baseURL + "/" + route,
            parameters: fullParameters)
            .validate()
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .Success:
                    let json = JSON(response.result.value!)
                    completion?(json)
                case .Failure(let error):
                    failure?(error, nil)
                }
        }
    }
    
    class func genericApiError(view: UIViewController, message: String? = nil) {
//        let text = message ?? "Could not connect to drink database. Are you connected to the internet?"
//        DrinkAlertView().show(view, title: "API Error", text: text, buttonText: "OK")
    }
    
}