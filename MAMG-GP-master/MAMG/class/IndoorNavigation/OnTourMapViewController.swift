//
//  OnTourMapViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//


import Foundation
import UIKit
import WebKit
import CoreLocation
import Alamofire
import SwiftyJSON

struct objTour {
    var tName: String
    var tourID: Int
    var objectID: Int
    var hallID: Int
    var geoID: Int
    var lat: Double
    var long: Double
    var distance: Double
    
    init(tName: String, tourID: Int, objectID: Int, hallID: Int, geoID: Int, lat: Double, long: Double, distance: Double) {
        self.tName = tName
        self.tourID = tourID
        self.objectID = objectID
        self.hallID = hallID
        self.geoID = geoID
        self.lat = lat
        self.long = long
        self.distance = distance
    }
}
class OnTourMapViewController: UIViewController, WKNavigationDelegate, CLLocationManagerDelegate {
//VARIABLES
    
    let locationManager = CLLocationManager()
    
    var direction = 0;
    let urlOnTour = "http://192.168.64.2/dashboard/MyWebServices/api/getOnTour.php"
    
    let objectArray = NSMutableArray()
    var sortedobjectArray = NSMutableArray()
    
    var tourID: Int = 0
    var idPar = ["id":0]
    let lastRow = 0
    
    var minDistance = 0.0
    var indexOfminDistance = 0
    var userLatitude = 0.0
    var userLongitude = 0.0
    
    var tourName: String = "X"
    
    var locationSet = false
    var distSet = false
    var foundMinDist = false
    var setNav = false
    var webLoaded = false
    //remove
    var isItArabic = false
    
    //OUTLETS
    @IBOutlet weak var ObjectName: UILabel!
    @IBOutlet weak var scitechMapWeb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        
        //call to get authurization
        requestAuthurization()
        
        scitechMapWeb.navigationDelegate = self
        //set tour id as parameter to be sent to api
        idPar = ["id": tourID]
        //set interface title
        ObjectName.text = tourName + " Tour"
        //set weblink to indoor map
        let url = URL(string: "http://192.168.64.2/dashboard/scitech2.html")!
        scitechMapWeb.load(URLRequest(url: url))
        
        //mapObj
        self.performSegue(withIdentifier: "mapObj", sender: self)
        
        getTObj()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapObj"){
            let hallInfoVC = segue.destination as! OnTourObjViewController
        }
    }
    
    //request authurization from user to get their current location
    func requestAuthurization(){
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            //once authurization is given then the application can start getting the location
            self.locationManager.delegate = self as! CLLocationManagerDelegate
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
            
        }else {
            print("access rejected")
        }
    }
    
    //When the web is completely loaded then the boolean varaiable is set to true
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webLoaded = true
    }
    
    //Function called every time users position updates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Getting user location from sensor
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        userLatitude = location.latitude
        userLongitude = location.longitude
        
        //Once web is loaded, then users location are sent to the website
        if webLoaded {
            scitechMapWeb.evaluateJavaScript("updatedUserLocation(\(userLatitude), \(userLongitude))", completionHandler:{ (result, error) in
                guard error == nil else {
                    print("there was an error")
                    print(error.debugDescription)
                    return
                }
                print(result)
            })
        }
        
        print("got your location")
        
        
        //Gets distance between user and each object
        if (locationSet){
            locationSet = false
            findDistanceToObject()
        }
        
        //Find min distance to object
        if distSet {
            distSet = false
            findMinDist()
        }
        
        //sends to function to send to indoor map
        if foundMinDist && webLoaded {
            print("sending...")
            setNav = true
            sendNavToHTML(userLat: userLatitude, userLon: userLongitude, index: indexOfminDistance)
            
        }
    }
    
    
    func findDistanceToObject(){
        for row in 0..<objectArray.count{
            var locationData = objectArray[row] as! objTour
            let obj = locationData.objectID
            let objLat = locationData.lat
            let objLong = locationData.long
            
            var newLat = 0.0
            var newLon = 0.0
            
            //convert lat and long to x(east, west) and z(north, south)
            (newLon, newLat) = self.convertTo(x: userLongitude, z: userLatitude, ObjectLongitude: objLong, ObjectLatitude: objLat)
            
            // Using the two results from the latitude and longitude to calculate the distance between the object and users device
            let dis = sqrt(pow(newLon, 2.0)+pow(newLat, 2.0))
            //save new distance to array
            locationData.distance = dis
            
            print("got lat \(newLat) long \(newLon)")
            print("got obj \(obj)")
            print("got dis \(dis)")
            
            if (row == (objectArray.count - 1)){
                distSet = true
            }
        }
    }
    
    //Function to find min distance to objects in tour
    
    func findMinDist(){
        var locationData = objectArray[0] as! objTour
        var min = locationData.distance
        var index = 0
        var last = objectArray.count - 1
        
        
        for row in 1..<objectArray.count{
            var locationData = objectArray[row] as! objTour
            var dis = locationData.distance
            //check if the distance is the closest and set that as the new minimum
            if dis<min{
                min = dis
                print("got min \(min)")
                minDistance = min
                index = row
                indexOfminDistance = index
            }
            
            if last == row {
                foundMinDist = true
            }
        }
    }

    
    //Function to send the start and destination position to the indoor map
    //It also continously calculates the users position and the distanse to object
    //After getting 10 m close to object, the object info interface opens and once
    //closed removes object from tour
    
    func sendNavToHTML(userLat: Double, userLon: Double, index: Int){
        var locationData = objectArray[index] as! objTour
        var objLat = locationData.lat
        var objLong = locationData.long
        var objID = locationData.objectID
        var direction = locationData.geoID
        
        print("**  Sending...  **")
        
        if setNav {
            
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
        
        var (Lon, Lat) = self.convertTo(x: userLongitude, z: userLatitude, ObjectLongitude: objLong, ObjectLatitude: objLat)
        
        // Using the two results from the latitude and longitude to calculate the distance between the object and users device
        let dis: Double = sqrt(pow(Lon, 2.0)+pow(Lat, 2.0))
        
        //Adaptive part: once the disyance between the user and the object is less than 10 meters, then open object info interface and once that interface is closed, remove that object from list and recalculate objects distance to fins newest closest object to user too navigate him to it
        if dis < 10.0 {
            if isItArabic {
                let objVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "objTAR") as! OnTourObjViewController
                objVC.ObjectID = objID
                objVC.modalPresentationStyle = .overFullScreen
                self.present(objVC, animated: true, completion: {
                    self.objectArray.removeObject(at: index)
                    self.foundMinDist = false
                    self.setNav = false
                })
                
            } else {
                let objVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "objTE") as! OnTourObjViewController
                objVC.ObjectID = objID
                objVC.modalPresentationStyle = .overFullScreen
                self.present(objVC, animated: true, completion: {
                    self.objectArray.removeObject(at: index)
                    self.foundMinDist = false
                    self.setNav = false
                })
            }
        }
    }
    
    //Function to convert Lat and Long to X and Z
    
    func convertTo(x: Double, z: Double, ObjectLongitude: Double, ObjectLatitude: Double) -> (PositionX: Double, PositionZ: Double){
        var PositionX: Double = 0.0
        var PositionZ: Double = 0.0
        
        print("users location \(x) - \(z)")
        print("obj location \(ObjectLongitude) - \(ObjectLatitude)")
        
        // Converting latitude and longitude to meters (swift is in meters)
        if ((ObjectLatitude > 0 && z < 0) || (ObjectLatitude < 0 && z > 0)){
            PositionZ = z + ObjectLatitude
        } else if (ObjectLatitude > z) {
            PositionZ = z - ObjectLatitude
        } else { PositionZ = ObjectLatitude - z }
        
        print("Z: \(PositionZ)")
        
        if ((ObjectLongitude > 0 && x < 0) || (ObjectLongitude < 0 && x > 0)){
            PositionX = x + ObjectLongitude
        } else if (ObjectLatitude > x) {
            PositionX = x - ObjectLongitude
        } else { PositionX = ObjectLongitude - x }
        
        print("Z: \(PositionX)")
        
        PositionX *= 111139 * cos(PositionZ)
        PositionZ *= 111139
        
        print("New X: \(PositionX) New Z: \(PositionZ)")
        
        return (PositionX, PositionZ)
    }
    
    //Function get the list of object in the tour with the object location for the indoor map
    
    func getTObj(){
        Alamofire.request(urlOnTour, method: .post, parameters: idPar).responseData(completionHandler: {(response) in
            if response.result.isSuccess {
                let ObjJSON : JSON = JSON(response.data)
                let lastRow = ObjJSON["objectdata"].count
                print("getting obj")
                print(ObjJSON);
                for row in 0..<lastRow{
                    var TourName = ObjJSON["objectdata"][row]["Name_E"].stringValue
                    var TourID = ObjJSON["objectdata"][row]["Tour_id"].intValue
                    var ObjID = ObjJSON["objectdata"][row]["Object_id"].intValue
                    var hallID = ObjJSON["objectdata"][row]["Hall_id"].intValue
                    var geoID = ObjJSON["objectdata"][row]["geoID"].intValue
                    var lat = ObjJSON["objectdata"][row]["lat"].doubleValue
                    var Long = ObjJSON["objectdata"][row]["lon"].doubleValue
                    
                    self.objectArray.add(objTour.init(tName: TourName, tourID: TourID, objectID: ObjID, hallID: hallID, geoID: geoID, lat: lat, long: Long, distance: 0.0))
                }
                self.locationSet = true
            }
        })
    }
    
    @IBAction func backToMain(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Function not complete: to fins users location based on (AC: distance between user and beacon 1, BC: distance between user and beacon 2, AB: distance between beacon 1 and beacon 2, By: position y of beacon 2, Bx: position x of beacon 2, Ay: position y of beacon 1, Ax: position x of beacon 1)
    //using these values, the below function should get the users location indoors
    func locateUserByBeacons(AC: Double, BC: Double, AB: Double, By: Double, Bx: Double, Ay: Double, Ax: Double){
        //φ1=arctan2(𝐵𝑦−𝐴𝑦,𝐵𝑥−𝐴𝑥)
        let delta1 = atan2(By-Ay, Bx-Ax)
        //l=𝑙21+𝑙23−𝑙222⋅𝑙1⋅𝑙3
        let l = (pow(AC, 2.0)+pow(AB, 2.0)-pow(BC, 2.0))/(2*AC*AB)
        //φ2=arccos(l)
        let delta2 = acos(l)
        //𝐶=𝐴+𝑙1⋅[cos(φ1±φ2); sin(φ1±φ2)]
        let Cx = Ax + (AC * (cos(delta1+delta2)))
        let Cy = Ay + (AC * (sin(delta1+delta2)))
    }
    

}
