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
        
        requestAuthurization()
        
        scitechMapWeb.navigationDelegate = self
        
        let url = URL(string: "http://192.168.64.2/dashboard/scitech2.html")!
        scitechMapWeb.load(URLRequest(url: url))
    }
    
    func requestAuthurization(){
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            
        }else {
            print("access rejected")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("switched")
        webFinishedLoading = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        userLatitude = 26.319387//location.latitude
        userLongitude = 50.227697//location.longitude
        
        print("\n\n **********\n \(userLatitude) - \(userLongitude) \n*******\n\n")
        
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
    
    

    

   


