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

    //TODO: •    The user has the option to start the tour or add it to the favorites.
    //•    After the user clicks favorite, then a flag value will display if the user is signed in.
    //•    If the name is not signed in, then the user will be redirected to the Sign in interface.
    //•    If the name is signed in, then the tour will be added to the users' favorite tours.
    //•    After the user clicks start, then the user will be redirected to the on tour interface.
    
    @IBOutlet weak var saveTour: UIButton!
    @IBOutlet weak var startTour: UIButton!
    
    var hallsSelected : [String] = []
    var ObjSelected : [String] = []
    var tourID: Int = 0
    var tourName: String = ""
    let ObjURL = URLNET+"savePlannedTour.php"
    let UserURL = URLNET+"saveUsersTour.php"
    var parameterUser: [String : Any] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUserAGust {
            saveTour.isHidden = true
        } else {
            saveTour.isHidden = false
            parameterUser = ["UserID": usersEmaile, "TourID": tourID]
        }
    }
    
    @IBAction func saveTourInDB(_ sender: Any) {
        print("***************************************\n\n\n")
        print("***************************************")
        print( "Object ID:")
        print(ObjSelected)
        print( "Tour ID: \(tourID)")
        print( "User ID: \(usersEmaile)")
        
        if !usersEmaile.isEmpty {
            setUser()
        }
        
        setObjs()
        
    }
    
    func setUser(){
        print("Setting user")
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
    
    func setObjs(){
        //Objects is uploaded intoDB
        for row in 0..<ObjSelected.count{
            print("Setting obj")
            let objID = ObjSelected[row]
            var parameterObj: [String : Any] = ["ObjID": objID, "TourID": tourID, "UserID": usersEmaile]
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
    
    @IBAction func startOnTour(_ sender: Any) {
//        //TODO: Indoor Nav Segue
//        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapTE") as! OnTourMapViewController
//        cv.tourName = tourName
//        cv.tourID = tourID
//        self.present(cv, animated: true, completion: nil)
        self.performSegue(withIdentifier: "mapTE", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapTE"){
            let cv = segue.destination as! OnTourMapViewController
            cv.tourName = tourName
            cv.tourID = tourID
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if isItArabic {
            //
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanATour3AR") as! PlanATour3ViewController
            cv.hallsSelected = hallsSelected
            cv.tourID = tourID
            self.present(cv, animated: true, completion: nil)
            
        } else {
            
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanATour3E") as! PlanATour3ViewController
            cv.hallsSelected = hallsSelected
            cv.tourID = tourID
            self.present(cv, animated: true, completion: nil)
            
        }
    }
}
