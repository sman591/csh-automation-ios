//
//  ApiViewController.swift
//  CSH Automation
//
//  Created by Stuart Olivera on 2/25/16.
//  Copyright © 2016 Stuart Olivera. All rights reserved.
//


import UIKit
import KeychainAccess
import Alamofire
import SwiftyJSON

class ApiViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var apiFieldOutlet: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func openWebDrinkAction(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://webdrink.csh.rit.edu/mobileapp/index.php")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiFieldOutlet.becomeFirstResponder()
        apiFieldOutlet.delegate = self
        addParallax()
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateApiKey", name: UIApplicationDidBecomeActiveNotification, object: UIApplication.sharedApplication())
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateApiKey() {
        if (CurrentUser.getApiKey()?.isEmpty == false) {
            apiFieldOutlet.text = CurrentUser.getApiKey()
            self.view.endEditing(true)
            submitApiKey()
        }
    }
    
    func submitApiKey() {
        let apiKey = self.apiFieldOutlet.text!
        self.activityIndicator.startAnimating()
        debugPrint(apiKey)
        AutomationApi.verifyApiKey(apiKey,
            completion: { data in
                debugPrint(data)
                if data.boolValue {
                    self.handleValidApiKey(apiKey)
                }
                else {
                    self.handleInvalidApiKey()
                }
                self.activityIndicator.stopAnimating()
            },
            failure: { errorData, message in
                self.handleInvalidApiKey()
                self.activityIndicator.stopAnimating()
            }
        )
    }
    
    func handleValidApiKey(apiKey: String) {
        CurrentUser.setApiKey(apiKey)
        CurrentUser.updateUser()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleInvalidApiKey() {
        CurrentUser.logout()
//        let alertview = DrinkAlertView().show(self, title: "Invalid API Key", text: "Please check your key and try again.", buttonText: "OK")
//        alertview.setTextTheme(.Light)
//        alertview.addAction() {
//            self.apiFieldOutlet.becomeFirstResponder()
//            return
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let shouldReturn = textField.text!.characters.count == 20
        if shouldReturn {
            textField.resignFirstResponder()
            submitApiKey()
        }
        return shouldReturn
    }
    
    func addParallax() {
        let relativeAbsoluteValue = 15
        
        // Set vertical effect
        let verticalMotionEffect =  UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -1 * relativeAbsoluteValue
        verticalMotionEffect.maximumRelativeValue = relativeAbsoluteValue
        
        // Set horizontal effect
        let horizontalMotionEffect =  UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        horizontalMotionEffect.minimumRelativeValue = -1 * relativeAbsoluteValue
        horizontalMotionEffect.maximumRelativeValue = relativeAbsoluteValue
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        self.backgroundImage.addMotionEffect(group)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > textField.text!.utf16.count {
            return false
        }
        
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        return newLength <= 20
    }
    
}
