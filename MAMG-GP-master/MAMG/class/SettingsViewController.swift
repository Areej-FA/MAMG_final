//
//  SettingsViewController.swift
//  MAMG
//
//  Created by Areej on 1/14/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var autoPlaySound_Ar: UISwitch!
    @IBOutlet weak var autoPlaySound_En: UISwitch!
    @IBOutlet weak var languageSelection_En: UISegmentedControl!
    @IBOutlet weak var languageSelection_Ar: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //Function to set autoplay enabled or disabled
    @IBAction func playSound(_ sender: Any) {
        if (sender as! UISwitch).isOn {
            autoPlaySound = true
        }else{
            autoPlaySound = false
        }
    }
    
    //Function to redirect to other lanuague interface
    @IBAction func selectLanguage(_ sender: Any) {
        if (isItArabic){
            isItArabic = false
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC_En") as! SettingsViewController
            self.present(cv, animated: true, completion: nil)
        }else{
            isItArabic = true
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC_Ar") as! SettingsViewController
            self.present(cv, animated: true, completion: nil)
        }
    }
    
 

}
