//
//  OnTourObjViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OnTourObjViewController: UIViewController {
    
    let getAnObject: String = URLNET + "getAnObject.php"
    var ObjectID = 0
    var videoLink: String = ""
    var resourceLink: String = ""
    var parID: Dictionary<String,Int> = [:]
    var tName: String = ""
    //OUTLETS
    
    @IBOutlet weak var ObjectName: UILabel!
    @IBOutlet weak var ObjectImage: UIImageView!
    @IBOutlet weak var ObjectDescribtion: UILabel!
    @IBOutlet weak var ObjectVideo: UIButton!
    @IBOutlet weak var ObjectLink: UIButton!
    @IBOutlet weak var audioLevel: UISlider!
    @IBOutlet weak var audioIcon: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var parID = ["id": 3]
        
        ObjectName.text = tName  + " Tour"
        
        getObjectInfo(ObjectID: parID)
        

   
    }
    
    //get object info from the object that the use was naviagted to
    func getObjectInfo(ObjectID: Dictionary<String,Int>){
        
        Alamofire.request(getAnObject, method: .post, parameters: ObjectID).responseData { (response) in
            
            if response.result.isSuccess{
                print("Success! Got the object data")
                let ObjectJSON : JSON = JSON(response.data)
                
                print(ObjectJSON)
                self.dataOfJson(json: ObjectJSON)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //set the info in interface
    func dataOfJson(json: JSON){
        
        if isItArabic {
            //Object Arabic Name
            if let name = json["object"][0]["Name_AR"].string {
                ObjectName.text = name
            } else {
                ObjectName.text = ""
            }
            
            if let desc = json["object"][0]["Description_AR"].string {
                ObjectDescribtion.text = desc
            } else {
                ObjectDescribtion.text = ""
            }
            
            if let video = json["object"][0]["Video_AR"].string {
                videoLink = video;
                
            } else {
                ObjectVideo.isHidden = true
            }
            
            if let resource = json["object"][0]["Resource_AR"].string {
                resourceLink = resource;
                
            } else {
                ObjectLink.isHidden = true
            }
            
            if let resource = json["object"][0]["Audio_AR"].string {
                
                
            } else {
                audioLevel.isHidden = true
                audioIcon.isHidden = true
            }
            
        } else {
            //Object English Name
            if let name = json["object"][0]["Name_E"].string {
                ObjectName.text = name
            } else {
                ObjectName.text = ""
            }
            
            if let desc = json["object"][0]["Description_E"].string {
                ObjectDescribtion.text = desc
            } else {
                ObjectDescribtion.text = ""
            }
            
            if let video = json["object"][0]["Video_E"].string {
                videoLink = video;
                
            } else {
                ObjectVideo.isHidden = true
            }
            
            if let resource = json["object"][0]["Resource_E"].string {
                resourceLink = resource;
                
            } else {
                ObjectLink.isHidden = true
            }
            
            if let resource = json["object"][0]["Audio_E"].string {
                
                
            } else {
                audioLevel.isHidden = true
                audioIcon.isHidden = true
            }
            
        }
        //Download image
        if json["object"][0]["Picture"].stringValue != "null"{
            let encodedImage = json["object"][0]["Picture"].stringValue
            let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0)) //Get image url from json and send it to function to download
            ObjectImage.image = UIImage(data: imageData!)
        }else {
            ObjectImage.image = UIImage(named: "diamond")
        }
        
        
        //TODO: Audio
        
        
    }
    
    
    @IBAction func openVideoWebpage(_ sender: Any) {
        let settingsUrl = NSURL(string:videoLink)! as URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func openResourceWebpage(_ sender: Any) {
        let settingsUrl = NSURL(string:resourceLink)! as URL
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
    
    //Bookmark object and insert it into database
    @IBAction func SetObjectinBookmark(_ sender: Any) {
        let setURL: String = URLNET + "setObjectInBookmark.php"
        
        Alamofire.request(setURL, method: .post, parameters: parID).responseData { (response) in
            
            if response.result.isSuccess{
                print("Success! Got the object data")
                
                let isAdded : JSON = JSON(response.data)
                if (isAdded[0] == "successfully"){
                    print("Added")
                }else{
                    print("Try again later")
                }
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    @IBAction func startOnTour(_ sender: Any) {
        //TODO: Indoor Nav Segue
        let cv = UIStoryboard(name: "IndoorNavigation", bundle: nil).instantiateViewController(withIdentifier: "mapTE") as! OnTourMapViewController
        self.present(cv, animated: true, completion: nil)
    }
}
