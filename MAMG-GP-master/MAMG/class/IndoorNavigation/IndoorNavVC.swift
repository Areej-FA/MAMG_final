//
//  IndoorNavVC.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import Alamofire
import CoreLocation

class IndoorNavVC: UIViewController, WKNavigationDelegate, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var scitechMapWeb: WKWebView!
    
    
    let locationManager = CLLocationManager()
    var direction = 0;
    var userLatitude = 0.0//location.latitude
    var userLongitude = 0.0//location.longitude
    
    var webFinishedLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call to get authurization
        requestAuthurization()
        
        scitechMapWeb.navigationDelegate = self
        
        //set weblink to indoor map
        let url = URL(string: "http://192.168.64.2/dashboard/scitech2.html")!
        scitechMapWeb.load(URLRequest(url: url))
    }
    
    //request authurization from user to get their current location
    func requestAuthurization(){
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            //once authurization is given then the application can start getting the location
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            
        }else {
            print("access rejected")
        }
    }
    
    //When the web is completely loaded then the boolean varaiable is set to true
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("switched")
        webFinishedLoading = true
    }
    
    //Function called every time users position updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Getting user location from sensor
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        userLatitude = location.latitude
        userLongitude = location.longitude
        
        print("\n\n **********\n \(userLatitude) - \(userLongitude) \n*******\n\n")
        
        //Once web is loaded, then users location are sent to the website

        if webFinishedLoading {
            scitechMapWeb.evaluateJavaScript("updatedUserLocation(\(userLatitude), \(userLongitude))", completionHandler:{ (result, error) in
                guard error == nil else {
                    print("there was an error")
                    print(error.debugDescription)
                    return
                }
                print(result)
            })
        }
        
        
    }
    
    @IBAction func navToMosque(_ sender: Any) {
        direction = 0
    }
    
    @IBAction func navToIMAX(_ sender: Any) {
        direction = 24101890
    }
    
    //Once web is loaded and direction is set, then users location and direction are sent to the website to set indoor naviagtion to scitech hall

    @IBAction func navToHalls(_ sender: Any) {
        direction = 24100582
        if direction != 0 && webFinishedLoading{
            scitechMapWeb.evaluateJavaScript("setNav(\(userLatitude), \(userLongitude), \(direction))", completionHandler:{ (result, error) in
                guard error == nil else {
                    print("there was an error")
                    print(error.debugDescription)
                    print(error?.localizedDescription)
                    return
                }
                print(result)
            })
        }
        
    }
    
    //Once web is loaded and direction is set, then users location and direction are sent to the website to set indoor naviagtion to restroom
    
    @IBAction func navToWashroom(_ sender: Any) {
        
        direction = 24099164
        if direction != 0 && webFinishedLoading{
            scitechMapWeb.evaluateJavaScript("setNav(\(userLatitude), \(userLongitude), \(direction))", completionHandler:{ (result, error) in
                guard error == nil else {
                    print("there was an error")
                    print(error.debugDescription)
                    print(error?.localizedDescription)
                    return
                }
                print(result)
            })
        }
    }
    
}
    
    

    

   


