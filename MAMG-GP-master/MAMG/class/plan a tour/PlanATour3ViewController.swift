//
//  PlanATour3ViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 25/02/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct ObjsName{
    var ObjID: String
    var ObjName: String
    var ObjImg: Data
    var selectedObject: Bool = false
    
    init(ObjID: String, ObjName: String, ObjImg: Data) {
        self.ObjID = ObjID
        self.ObjName = ObjName
        self.ObjImg = ObjImg
    }
}


class PlanATour3ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var tourID: Int = 0
    var tourName: String = ""
    var url = "http://192.168.64.2/dashboard/MyWebServices/api/getObjects.php"
    var ObjArray: NSMutableArray = NSMutableArray()
    var hallsSelected : [String] = []
    var ObjSelected : [String] = []
    var selectAll: Bool = false
    
    
    @IBOutlet weak var ObjTable: UITableView!
    
    //TODO: •    This interface presents the scientific objects for the specified hall by retrieving them from the database.
    //•    The user can select the scientific objects they want to visit on their tour.
    //•    After the user clicks next, then the scientific objects selected by the user will be stored in an array.
    //•    If the array is empty, then the user has to select at least one scientific object.
    //•    If the array is not empty, then the user will be redirected to the plan a tour step 4 interface and those scientific objects will be added to the database.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ObjTable.dataSource = self
        ObjTable.delegate = self
        
        getObj()
    }
    
    func getObj(){
        for row in 0..<hallsSelected.count{
            let hallID = hallsSelected[row]
            let parameter = ["id": hallID]
            
            Alamofire.request(url, method: .post, parameters: parameter).responseData(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    let ObjJSON : JSON = JSON(response.data as Any)
                    print(ObjJSON)
                    
                    let lastRow = ObjJSON["objectdata"].count
                    
                    for row in 0..<lastRow{
                        var ObjID = ObjJSON["objectdata"][row]["Object_id"].string!
                        var ARName = ObjJSON["objectdata"][row]["Name_AR"].string!
                        var EName = ObjJSON["objectdata"][row]["Name_E"].string!
                        var encodedImage = ObjJSON["objectdata"][row]["Picture"].string!
                        let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                        
                        
                        if isItArabic {
                            self.ObjArray.add(ObjsName.init(ObjID: ObjID, ObjName: ARName, ObjImg: imageData!))
                            self.reloadTable()
                        }else{
                            self.ObjArray.add(ObjsName.init(ObjID: ObjID, ObjName: EName, ObjImg: imageData!))
                            self.reloadTable()
                        }
                    }
                } else {
                    print("Error \(String(describing: response.result.error))")
                }
                
            })
        }
    }
    
    func reloadTable(){
        //print("***reload")
        //print("Img Array: \(imgArray.count)")
        ObjTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ObjTable.dequeueReusableCell(withIdentifier: "ObjCell", for: indexPath) as! PlanATour3TableViewCell
        //print("Set cells")
        
        let ObjInfo = ObjArray[indexPath.row] as! ObjsName
        cell.ObjName.text = ObjInfo.ObjName
        cell.ObjImg.image = UIImage(data: ObjInfo.ObjImg)
        
        if selectAll {
            var id = ObjInfo.ObjID
            if !ObjSelected.contains(id){
                ObjSelected.append(id)
                print("Set button to cancel")
                cell.ObjSelect.image = UIImage(named: "cancel")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count")
        return ObjArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.ObjTable.cellForRow(at: indexPath) as! PlanATour3TableViewCell
        print("&&&\(hallsSelected)")
        let ObjInfo = ObjArray[indexPath.row] as! ObjsName
        var id = ObjInfo.ObjID
        if ObjSelected.contains(id){
            if let index = ObjSelected.firstIndex(of: id) as Int?{
                ObjSelected.remove(at: index)
                print("Set button to add")
                cell.ObjSelect.image = UIImage(named: "add")
            } else {
                print("Nothing to remove")
            }
        } else {
            ObjSelected.append(id)
            print("Set button to cancel")
            cell.ObjSelect.image = UIImage(named: "cancel")
        }
        reloadTable()
        print("&&&\(ObjSelected)")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func NextStep(_ sender: Any) {
        if ObjSelected.isEmpty {
            if isItArabic{
                //TODO: Translate
                //alertMessage(TitleOfMessage: <#T##String#>, Message: <#T##String#>, Okay: <#T##String#>)
            } else {
                alertMessage(TitleOfMessage: "Nothing selected", Message: "Please select at least one scientific hall to proceed to the 3rd step", Okay: "OK")
            }
            
        } else {
            self.performSegue(withIdentifier: "PlanATour4E", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour4E"){
            let cv = segue.destination as! PlanATour4ViewController
            cv.tourID = tourID
            cv.tourName = tourName
            cv.ObjSelected = ObjSelected
            cv.hallsSelected = hallsSelected
        }
    }
    
    @IBAction func SelectAllObjects(_ sender: Any) {
        if selectAll {
            selectAll = false
        } else {
            selectAll = true
        }
        reloadTable()
    }
    
    @IBAction func backBtn(_ sender: Any) {
    }
    
    
    func alertMessage(TitleOfMessage: String, Message: String, Okay: String){
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default, handler: nil)
        alertPrompt.addAction(confirmAction)
        present(alertPrompt, animated: true, completion: nil)
    }
}
