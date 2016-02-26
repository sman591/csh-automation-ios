//
//  SecondViewController.swift
//  CSH Automation
//
//  Created by Stuart Olivera on 2/25/16.
//  Copyright © 2016 Stuart Olivera. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {

    @IBOutlet weak var projectorPower: UISwitch!
    @IBAction func projectorPowerChangeed(sender: UISwitch) {
        if sender.on {
            print("it's on!")
        } else {
            print("it's off.")
        }
        
        AutomationApi.loungeProjectorTogglePower(sender.on)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

