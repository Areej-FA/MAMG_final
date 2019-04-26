//
//  VisitTimeViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 19/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VisitTimeViewController: UIViewController {

        //MARK:
        let DataURL: String = URLNET + "visitTime.php"
        var visitTimeJSON : JSON = []
        
        //MARK:
        @IBOutlet weak var dayOne: UILabel!
        @IBOutlet weak var dayTwo: UILabel!
        @IBOutlet weak var dayThree: UILabel!
        @IBOutlet weak var dayFour: UILabel!
        @IBOutlet weak var dayFive: UILabel!
        @IBOutlet weak var daySix: UILabel!
        @IBOutlet weak var daySeven: UILabel!
        @IBOutlet weak var dayOneMorningTime: UILabel!
        @IBOutlet weak var dayTwoMorningTime: UILabel!
        @IBOutlet weak var dayThreeMorningTime: UILabel!
        @IBOutlet weak var dayFourMorningTime: UILabel!
        @IBOutlet weak var dayFiveMorningTime: UILabel!
        @IBOutlet weak var daySixMorningTime: UILabel!
        @IBOutlet weak var daySevenMorningTime: UILabel!
        @IBOutlet weak var dayOneNightTime: UILabel!
        @IBOutlet weak var dayTwoNightTime: UILabel!
        @IBOutlet weak var dayThreeNightTime: UILabel!
        @IBOutlet weak var dayFourNightTime: UILabel!
        @IBOutlet weak var dayFiveNightTime: UILabel!
        @IBOutlet weak var daySixNightTime: UILabel!
        @IBOutlet weak var daySevenNightTime: UILabel!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //MARK:
            if (isItArabic == true){
                dataToJson(url: DataURL, lang: ["language" : "Ar"])
            }else{
                dataToJson(url: DataURL, lang: ["language" : "E"])
            }
        }
        
        //MARK:
        func dataToJson(url: String, lang: [String: String]){
            Alamofire.request(url, method: .post, parameters: lang ).responseData { (response) in
                if response.result.isSuccess{
                    //MARK:
                    let visitTimeJSON : JSON = JSON( response.result.value! )
                    print(visitTimeJSON)
                    self.updateUi(data: visitTimeJSON)
                }else {
                    print("Error \(String(describing: response.result.error))")
                }
            }
        }
        
        //MARK:
        func updateUi(data: JSON)  {
            //MARK:
            dayOne.text = data[0]["Days"].string
            dayOneMorningTime.text = data[0]["Morning (9 - 12)"].string
            dayOneNightTime.text = data[0]["Night (4 - 9)"].string
            
            //MARK:
            dayTwo.text = data[1]["Days"].string
            dayTwoMorningTime.text = data[1]["Morning (9 - 12)"].string
            dayTwoNightTime.text = data[1]["Night (4 - 9)"].string
            
            //MARK:
            dayThree.text = data[2]["Days"].string
            dayThreeMorningTime.text = data[2]["Morning (9 - 12)"].string
            dayThreeNightTime.text = data[2]["Night (4 - 9)"].string
            
            //MARK:
            dayFour.text = data[3]["Days"].string
            dayFourMorningTime.text = data[3]["Morning (9 - 12)"].string
            dayFourNightTime.text = data[3]["Night (4 - 9)"].string
            
            //MARK:
            dayFive.text = data[4]["Days"].string
            dayFiveMorningTime.text = data[4]["Morning (9 - 12)"].string
            dayFiveNightTime.text = data[4]["Night (4 - 9)"].string
            
            //MARK:
            daySix.text = data[5]["Days"].string
            daySixMorningTime.text = data[5]["Morning (9 - 12)"].string
            daySixNightTime.text = data[5]["Night (4 - 9)"].string
            
            //MARK:
            daySeven.text = data[1]["Days"].string
            daySevenMorningTime.text = data[1]["Morning (9 - 12)"].string
            daySevenNightTime.text = data[1]["Night (4 - 9)"].string
        }

}
