//
//  PlanATour4ViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 25/02/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PlanATour4ViewController: UIViewController {
    
    //Connection to table view on interface
    @IBOutlet weak var saveTour: UIButton!
    @IBOutlet weak var startTour: UIButton!
    
    //Array of hall id from selected halls and objects from previous interface
    var hallsSelected : [String] = []
    var ObjSelected : [String] = []
    var tourID: Int = 0
    var tourName: String = ""
    //URL links to api
    let ObjURL = URLNET+"savePlannedTour.php"
    let UserURL = URLNET+"saveUsersTour.php"
    //parameters to send values to api
    var parameterUser: [String : Any] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check if users is logged in or not
        if isUserAGust {
            saveTour.isHidden = true
        } else {
            saveTour.isHidden = false
            //set user name and user id to parameter variable
            parameterUser = ["UserID": usersEmaile, "TourID": tourID]
        }
    }
    
    @IBAction func saveTourInDB(_ sender: Any) {
        
        if !usersEmaile.isEmpty {
            setUser()
        }
        
        setObjs()
    }
    
    //Function to save tour to favorite
    func setUser(){
        print("Setting user")
        //Alamofire request to send parameter values to database and insert them there
        Alamofire.request(UserURL, method: .post, parameters: parameterUser).responseData(completionHandler: {(response) in
            if response.result.isSuccess {
                
                let ObjJSON : JSON = JSON(response.data)
                print("user set")
                print(ObjJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        })
    }
    
    //Function to save tour objects in database
    func setObjs(){
        //Objects is uploaded intoDB
        //send each object to api and inserting them into T_Object table
        for row in 0..<ObjSelected.count{
            print("Setting obj")
            let objID = ObjSelected[row]
            var parameterObj: [String : Any] = ["ObjID": objID, "TourID": tourID, "UserID": usersEmaile]
            //Alamofire request to send parameter values to database and insert them there
            Alamofire.request(ObjURL, method: .post, parameters: parameterObj).responseData(completionHandler: {(response) in
                if response.result.isSuccess {
                    let ObjJSON : JSON = JSON(response.data)
                    print("obj set")
                    print(ObjJSON)
                } else {
                    print("Error \(String(describing: response.result.error))")
                }
            })
        }
    }
    
    //navigate(perform segue) to indoor naviagtion interface
    @IBAction func startOnTour(_ sender: Any) {
        self.performSegue(withIdentifier: "mapTE", sender: self)
    }
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapTE"){
            let cv = segue.destination as! OnTourMapViewController
            //Send tour id and tour nameto next interface
            cv.tourName = tourName
            cv.tourID = tourID
        }
    }
    
}
