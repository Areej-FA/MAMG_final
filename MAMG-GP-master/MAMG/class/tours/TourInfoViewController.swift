//
//  TourInfoViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 26/02/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//Structure model for objects
struct ObjsList{
    var ObjID: String
    var ObjName: String
    var ObjImg: String
    var selectedObject: Bool = false
    
    init(ObjID: String, ObjName: String, ObjImg: String) {
        self.ObjID = ObjID
        self.ObjName = ObjName
        self.ObjImg = ObjImg
    }
}

class TourInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //create object from class tourBean
    var Tour = TourBean()
    //set id from previous id
    var tourID = ""
    var objectID = ""
    var objects: NSMutableArray = NSMutableArray()
    var idPar = ["":""]
    //URL links to api
    let urlTour = URLNET + "getTour.php"
    let urlTObj = URLNET + "getTourObj.php"
    
    //Connection to table view on interface
    @IBOutlet weak var TourDescription: UILabel!
    @IBOutlet weak var TourImage: UIImageView!
    @IBOutlet weak var TourCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tour id
        idPar["id"] = tourID

        
        getTour()
        
        getTObj()
    }
    
    //Function to get tour info
    func getTour(){
        
        Alamofire.request(urlTour, method: .post, parameters: idPar).responseData(completionHandler: {(response) in
            if response.result.isSuccess {
                let TourJSON : JSON = JSON(response.data)
                print(TourJSON)
                let name = TourJSON["objectdata"][0]["Name_E"].stringValue
                let desc = TourJSON["objectdata"][0]["Description_E"].stringValue
                let image = TourJSON["objectdata"][0]["Picture"].stringValue
                
                self.title = name
                self.TourDescription.text = desc
                
                if let imageData = Data(base64Encoded: image) {
                    self.TourImage.image = UIImage(data: imageData)
                }
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        })
    }
    
    //function to get object for that tour
    func getTObj(){
        Alamofire.request(urlTObj, method: .post, parameters: idPar).responseData(completionHandler: {(response) in
            if response.result.isSuccess {
                let ObjJSON : JSON = JSON(response.data)
                print(ObjJSON)
                let ObjID = ObjJSON["objectdata"][0]["Object_id"].stringValue
                var name = ""
                if isItArabic {
                    name = ObjJSON["objectdata"][0]["Name_AR"].stringValue
                } else {
                    name = ObjJSON["objectdata"][0]["Name_E"].stringValue
                }
                let image = ObjJSON["objectdata"][0]["Picture"].stringValue
                
                self.objects.add(ObjsList.init(ObjID: ObjID, ObjName: name, ObjImg: image))
                
                self.TourCollectionView.reloadData()
            }else {
                print("Error \(String(describing: response.result.error))")
            }
        })
    }
    
    // number of columns
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (objects.count)
    }
    // to fill rows with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        let obj = objects[indexPath.row] as! ObjsList
        
        let featureImage = cell.viewWithTag(1) as! UIImageView
        let featureName = cell.viewWithTag(2) as! UILabel
        
        featureName.text = obj.ObjName
        
        if let imageData = Data(base64Encoded: (obj.ObjImg)) {
            featureImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    // to know which row was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = objects[indexPath.row] as! ObjsList
        
        objectID = obj.ObjID
        self.performSegue(withIdentifier: "ObjectInfoE", sender: self)
    }
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ObjectInfoE"){
            let objInfoVC = segue.destination as! ObjectInfoViewController
            objInfoVC.decodedURL = self.objectID
        }
    }
}
