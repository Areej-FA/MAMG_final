//
//  PlanATour2ViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 25/02/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct HallsName{
    var HallID: String
    var Name: String
    var UriName: Data
    var selectedHall: Bool! = false
    
    init(HallID: String, Name: String, UriName: Data) {
        self.HallID = HallID
        self.Name = Name
        self.UriName = UriName
    }
}
class PlanATour2ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    var tourID: Int = 0
    var url = "http://192.168.64.2/dashboard/MyWebServices/api/returnHalls.php"
    var nameArray: NSMutableArray = NSMutableArray()
    var hallsSelected : [String] = []
    var tourName: String = ""
    
    @IBOutlet weak var tableHalls: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableHalls.dataSource = self
        tableHalls.delegate = self
        
        getHalls()
    }
    
    func getHalls(){
        Alamofire.request(url, method: .post).responseData { (response) in
            if response.result.isSuccess{
                let ObjJSON : JSON = JSON(response.data)
                print(ObjJSON)
                
                let lastRow = ObjJSON["objectdata"].count
                print(lastRow)
                
                for row in 0..<lastRow{
                    var hallID = ObjJSON["objectdata"][row]["Hall_id"].string!
                    var ARName = ObjJSON["objectdata"][row]["Name_AR"].string!
                    var EName = ObjJSON["objectdata"][row]["Name_E"].string!
                    var encodedImage = ObjJSON["objectdata"][row]["Picture"].stringValue
                    print("\(row) : \(EName)")
                    let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                    print("*****Img Data : \(imageData!)")
                    
                    if isItArabic {
                        self.nameArray.add(HallsName.init(HallID: hallID, Name: ARName, UriName: imageData!))
                        self.reloadTable()
                    }else{
                        self.nameArray.add(HallsName.init(HallID: hallID, Name: EName, UriName: imageData!))
                        self.reloadTable()
                    }
                }
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    func reloadTable(){
        //print("***reload")
        //print("Img Array: \(imgArray.count)")
        tableHalls.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableHalls.dequeueReusableCell(withIdentifier: "HallCell", for: indexPath) as! PlanATour2TableCellViewController
        //print("Set cells")
        
        let HallNames = nameArray[indexPath.row] as! HallsName
        cell.ObjName.text = HallNames.Name
        cell.ObjImg.image = UIImage(data: HallNames.UriName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count")
        return nameArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableHalls.cellForRow(at: indexPath) as! PlanATour2TableCellViewController
        
        let HallNames = nameArray[indexPath.row] as! HallsName
        var id = HallNames.HallID
        if hallsSelected.contains(id){
            if let index = hallsSelected.firstIndex(of: id) as Int?{
                hallsSelected.remove(at: index)
                print("Set button to add")
                cell.SelHall.image = UIImage(named: "add")
            } else {
                print("Nothing to remove")
            }
        } else {
            hallsSelected.append(id)
            print("Set button to cancel")
            cell.SelHall.image = UIImage(named: "cancel")
        }
        reloadTable()
        print("&&&\(hallsSelected)")
        
    }
    
    @IBAction func NextStep(_ sender: Any) {
        if hallsSelected.isEmpty {
            if isItArabic{
                //TODO: Translate
                //alertMessage(TitleOfMessage: <#T##String#>, Message: <#T##String#>, Okay: <#T##String#>)
            } else {
                alertMessage(TitleOfMessage: "Nothing selected", Message: "Please select at least one scientific hall to proceed to the 3rd step", Okay: "OK")
            }
        } else {
            if isItArabic {
                //
                
            } else {
                self.performSegue(withIdentifier: "PlanATour3E", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour3E"){
            let cv = segue.destination as! PlanATour3ViewController
            cv.tourID = tourID
            cv.tourName = tourName
            cv.hallsSelected = hallsSelected
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if isItArabic {
            //
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanATour1_VC_Ar") as! PlanATour1ViewController
            cv.tourN = tourName
            self.present(cv, animated: true, completion: nil)
            
        } else {
            
            let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlanATour1_VC_En") as! PlanATour1ViewController
            cv.tourN = tourName
            self.present(cv, animated: true, completion: nil)
            
        }
    }
    
    
    func alertMessage(TitleOfMessage: String, Message: String, Okay: String){
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default, handler: nil)
        alertPrompt.addAction(confirmAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }

}
