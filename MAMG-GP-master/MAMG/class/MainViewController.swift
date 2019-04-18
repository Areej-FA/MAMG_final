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
//        let bar = self.navigationController?.navigationBar
//        bar?.tintColor = UIColor.white //Items Color
//        bar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //Title Color
//        bar?.barTintColor = UIColor.init(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0) //Background color
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

