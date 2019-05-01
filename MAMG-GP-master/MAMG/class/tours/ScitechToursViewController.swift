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
    
    var url: String = URLNET + "getScitechTours.php"
    var nameArray: NSMutableArray = NSMutableArray()
    var selectedTour: String = ""
    
    @IBOutlet weak var ScitechToursTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScitechToursTable.dataSource = self
        ScitechToursTable.delegate = self
        
        getScitechTours()
    }
   
    //function to get Scitech tour from database
    func getScitechTours(){
        print("just entered the function")
        Alamofire.request(url, method: .post).responseString { (response) in
            //if response was successed
            if response.result.isSuccess{
                /// parse json data
                print("Here i start")
                let toursJSON = JSON.init(parseJSON: response.value!)
                print("This is the json ***> \(toursJSON)")
                let array = toursJSON["scitechdata"].arrayValue
                if array.count < 1 {
                    let alert = UIAlertController(title: nil, message: "No tours added by Scitech at this moment", preferredStyle: .alert)
                    var confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                print(array)
                
                
                for i in 0..<array.count{
                    let TourID = toursJSON["scitechdata"][i]["Tour_id"].string!
                    let ARName = toursJSON["scitechdata"][i]["Name_Ar"].stringValue
                    let EName = toursJSON["scitechdata"][i]["Name_E"].stringValue
                    var encodedImage = toursJSON["scitechdata"][i]["Picture"].stringValue
                    print("\(i) : \(EName)")
                    
                    let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                    print("*****Img Data : \(imageData!)")
                    
                    //if no tours found show an alert
                    if isItArabic {
                        self.nameArray.add(ScitechTours.init(name: ARName, UriName: imageData!, id: TourID))
                        //reload table to add data
                        self.reloadTable()
                    }else{
                        self.nameArray.add(ScitechTours.init(name: EName, UriName: imageData!, id: TourID))
                        //reload table to add data
                        self.reloadTable()
                    }
                }
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //Function to reload table to add data
    func reloadTable(){
        ScitechToursTable.reloadData()
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    // to fill the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.ScitechToursTable.dequeueReusableCell(withIdentifier: "TourCell", for: indexPath) as? ScitechToursTableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let TourNames = nameArray[indexPath.row] as! ScitechTours
        cell.Sname.text = TourNames.name
        cell.Simage.image = UIImage(data: TourNames.UriName)
        
        return cell
    }
    
    //set row height function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //Function to get tour if from selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.ScitechToursTable.cellForRow(at: indexPath)
        //get row from array that cooresponds the selected cell
        let tour = nameArray[indexPath.row] as! ScitechTours
        selectedTour = tour.id
        self.performSegue(withIdentifier: "ScitechTour", sender: self)
    }
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ScitechTour"){
            let tourInfo = segue.destination as! TourInfoViewController
            //Send tour id to next interface
            tourInfo.tourID = self.selectedTour
        }
    }
}
