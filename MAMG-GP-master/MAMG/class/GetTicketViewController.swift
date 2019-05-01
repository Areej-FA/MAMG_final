//
//  GetTicketViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetTicketViewController: UIViewController {

    // interface elements
    @IBOutlet weak var ticketTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var numberOfAdultsLablel: UILabel!
    @IBOutlet weak var numberOfKidsLablel: UILabel!
    @IBOutlet weak var adultsStepper: UIStepper!
    @IBOutlet weak var kidsStepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    
    // varables
    var numberOfAdults : Double = 0
    var numberOfKids : Double = 0.0
    var price : Double = 0.0
    
    let DataURL: String = URLNET + "getTicket.php"
    var weatherJSON : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataToJson(url: DataURL)
        getPrice(type: "Scientific Halls")
    }
    
    //Get ticket prices from database
    func dataToJson(url: String){
        Alamofire.request(url, method: .get).responseData { (response) in
            if response.result.isSuccess{
                self.weatherJSON  = JSON( response.result.value! )
                
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    // get tab selected
    @IBAction func selectInfoType(_ sender: Any) {
        
        switch (sender as AnyObject).selectedSegmentIndex{
        case 0:
            print("Scientific Halls")
            getPrice(type: "Scientific Halls")
            break
        case 1:
            print("IMAX")
            getPrice(type: "IMAX")
            break
            
        case 2:
            print("Scientific Halls and IMAX")
            getPrice(type: "Scientific Halls and IMAX")
            break
            
        default:
            ProgressHUD.showError("Kindly select a tap")
            
        }
    }
    
    //increase price when + is selected for adult ticket prices
    @IBAction func adultsCounter(_ sender: Any) {
        //        print(adultsStepper.stepValue)
        numberOfAdults = adultsStepper.value
        numberOfAdultsLablel.text = "\(numberOfAdults)"
        print(numberOfAdults)
        getPrice(type: "")
    }
    
    //increase price when + is selected for kids ticket prices
    @IBAction func kidsCounter(_ sender: Any) {
        numberOfKids = kidsStepper.value
        numberOfKidsLablel.text = "\(numberOfKids)"
        print(numberOfKids)
        getPrice(type: "")
    }
    
    //get total prices
    func getPrice(type: String) {
        var kidsTicketPrice : Double = 0.0
        var adultsTicketPrice : Double = 0.0
        switch type {
        case "Scientific Halls":
            if adultsStepper.value >= 5 {
                adultsTicketPrice = weatherJSON[2]["Price"].doubleValue
            }else{
                adultsTicketPrice = weatherJSON[0]["Price"].doubleValue
            }
            kidsTicketPrice = weatherJSON[1]["Price"].doubleValue
            break
        case "IMAX":
            if adultsStepper.value >= 5{
                adultsTicketPrice = weatherJSON[5]["Price"].doubleValue
            }else{
                adultsTicketPrice = weatherJSON[3]["Price"].doubleValue
            }
            kidsTicketPrice = weatherJSON[4]["Price"].doubleValue
            break
        case "Scientific Halls and IMAX":
            if adultsStepper.value >= 5{
                adultsTicketPrice = weatherJSON[8]["Price"].doubleValue
            }else{
                adultsTicketPrice = weatherJSON[6]["Price"].doubleValue
            }
            kidsTicketPrice = weatherJSON[7]["Price"].doubleValue
            break
        default:
            if adultsStepper.value >= 5{
                adultsTicketPrice = weatherJSON[2]["Price"].doubleValue
            }else{
                adultsTicketPrice = weatherJSON[0]["Price"].doubleValue
            }
            kidsTicketPrice = weatherJSON[1]["Price"].doubleValue
        }
        
        price = (numberOfKids * kidsTicketPrice) + ( numberOfAdults * adultsTicketPrice)
        print(price)
        priceLabel.text = "\(price)"
    }

}
