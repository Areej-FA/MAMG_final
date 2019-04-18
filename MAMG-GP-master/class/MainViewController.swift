//
//  MainViewController.swift
//  MAMG
//
//  Created by Areej on 12/24/18.
//  Copyright © 2018 Areej. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func Test(_ sender: Any) {
        //MARK this is success pop up code
        ProgressHUD.showSuccess("working on it!")
    }
    
    @IBAction func Test2(_ sender: Any) {
        //MARK this is error pop up code
        ProgressHUD.showError(" what happend ??")
    }
    
}

