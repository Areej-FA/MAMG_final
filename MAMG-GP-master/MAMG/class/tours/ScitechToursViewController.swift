//
//  ScitechToursViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



struct ScitechTours {
    var name: String = ""
    var UriName: Data
    var id : String = ""
    
}

class ScitechToursViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var url: String = "http://localhost:8888/MyWebServices-3/api/getScitechTours.php"
    var nameArray: NSMutableArray = NSMutableArray()
    
    
    @IBOutlet weak var ScitechToursTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScitechToursTable.dataSource = self
        ScitechToursTable.delegate = self
        
        getScitechTours()
       
    }
   
    
    
    func getScitechTours(){
        
        
        print("just entered the function")
        Alamofire.request(url, method: .post).responseString { (response) in
            if response.result.isSuccess{
                
                print("Here i start")
                let toursJSON = JSON.init(parseJSON: response.value!)
                print("This is the json ***> \(toursJSON)")
                let array = toursJSON["scitechdata"].arrayValue
                
                
                print(array)
                
                for i in 0..<array.count{
                    let TourID = toursJSON["scitechdata"][i]["Tour_id"].string!
                    let ARName = toursJSON["scitechdata"][i]["Name_Ar"].stringValue
                    let EName = toursJSON["scitechdata"][i]["Name_E"].stringValue
                    var encodedImage = toursJSON["scitechdata"][i]["Picture"].stringValue
                    print("\(i) : \(EName)")
                    
                    let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                    print("*****Img Data : \(imageData!)")
                    
                    if isItArabic {
                        self.nameArray.add(ScitechTours.init(name: ARName, UriName: imageData!, id: TourID))
                        self.reloadTable()
                    }else{
                        self.nameArray.add(ScitechTours.init(name: EName, UriName: imageData!, id: TourID))
                        self.reloadTable()
                    }
                }
            }else{
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        
    }
    
    
    func reloadTable(){
        ScitechToursTable.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.ScitechToursTable.dequeueReusableCell(withIdentifier: "TourCell", for: indexPath) as? ScitechToursTableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let TourNames = nameArray[indexPath.row] as! ScitechTours
        cell.Sname.text = TourNames.name
        cell.Simage.image = UIImage(data: TourNames.UriName)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isItArabic {
            
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TourInformationE") as! ToursInformationViewController
            let TourID = nameArray[indexPath.row] as! ScitechTours
            cv.tourID = TourID.id
            
            self.present(cv, animated: true, completion: nil)
            
        } else {
            
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TourInformationAr") as! ToursInformationViewController
            let TourID = nameArray[indexPath.row] as! ScitechTours
            cv.tourID = TourID.id
            
            self.present(cv, animated: true, completion: nil)
            
        }
        
    }
    
    
    

   
}
