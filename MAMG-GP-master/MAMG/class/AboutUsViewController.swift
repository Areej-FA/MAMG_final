//
//  AboutUsViewController.swift
//  MAMG
//
//  Created by Areej on 1/22/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    // MARK: all the var for this interface
   let allInformation = ScitechInformation(ar: isItArabic)
    @IBOutlet weak var scitechInfoControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scitechImg: UIImageView!
    var number : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !isItArabic {
            updateUi(num: number)
            descriptionLabel.textAlignment = NSTextAlignment.left
        }else{
            for i in 0...3{
                setSegTitle(num : i)
            }
            number = 3
            scitechInfoControl.selectedSegmentIndex = 3
             updateUi(num: number)
            descriptionLabel.textAlignment = NSTextAlignment.right
        }
        
    }
    // MARK: This function proived the index for the selected tap by the user
    @IBAction func selectInfoType(_ sender: Any) {
      
            switch (sender as AnyObject).selectedSegmentIndex{
            case 0:
                number = 0
                updateUi(num: number)
            case 1:
                number = 1
                updateUi(num: number)
            case 2:
                number = 2
                updateUi(num: number)
            case 3:
                number = 3
                updateUi(num: number)
            default:
                ProgressHUD.showError("Kindly select a tap")
   
        }
    }
   
    //MARK: the update ui method
    func updateUi(num: Int){
        scitechInfoControl.setTitle(allInformation.list[num].name, forSegmentAt: num)
        descriptionLabel.text = allInformation.list[num].description
        scitechImg.image = UIImage(named: allInformation.list[num].imagName)
    }
    
    //MARK: this function set the title for the taps on lode
    func setSegTitle(num : Int){
        scitechInfoControl.setTitle(allInformation.list[num].name, forSegmentAt: num)
    }

}
