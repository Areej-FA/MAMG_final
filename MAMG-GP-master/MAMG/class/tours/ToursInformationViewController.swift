//
//  ToursInformationViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Tours {
    var id : String
    var name: String
    var Desc: String
    var UriName: Data
    
    init(tourName: String, tourImg: Data, tourId: String, tourDesc: String){
        id = tourId
        name = tourName
        UriName = tourImg
        Desc = tourDesc
    }
}

class ToursInformationViewController: UIViewController {

    //Variables
    var nameArray: NSMutableArray = NSMutableArray()
    var url = "http://localhost:8888/MyWebServices-3/api/getScitechTours.php"
    var int: [String: String] = ["": ""]
    var tourID: String = ""
    
    @IBOutlet weak var tourImage: UIImageView!
    
    @IBOutlet weak var tourName: UILabel!
    
    @IBOutlet weak var tourDesc: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        int = ["id": tourID]; // Recieved value from Scitech tours
        getTheTourInfo(url: url, id: int)
    }
    
    func getTheTourInfo(url: String, id: [String:String]){
        Alamofire.request(url, method: .post, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                let ObjJSON = JSON(response.data)
                print("Success to get the information ")
                print(ObjJSON)
                self.Tours_info(json: ObjJSON)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    
    func Tours_info(json: JSON){
        if isItArabic  {
            //Object Arabic Name
            if let name = json["scitechdata"][0]["Name_AR"].string {
                tourName.text = name
            } else {
                tourName.text = ""
            }
            if let desc = json["scitechdata"][0]["Description_Ar"].string{
                tourDesc.text = desc
            } else {
                tourDesc.text = ""
            }
            
        } else {
            //Object English Name
            if let name = json["scitechdata"][0]["Name_E"].string {
                tourName.text = name
            } else {
                tourName.text = ""
            }
            
            if let desc = json["scitechdata"][0]["Description_E"].string {
                tourDesc.text = desc
            } else {
                tourDesc.text = ""
            }
            
        }
        
        //Download image
        let encodedImage = json["scitechdata"][0]["Picture"].stringValue
        let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
        if json["scitechdata"][0]["Picture"].stringValue != "null"{
            //Get image url from json and send it to function to download
            tourImage.image = UIImage(data: imageData!)
        }else {
            tourImage.image = UIImage(data: imageData!)
        }
        
    }

}
