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

//Structure model for objects
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
    //Tour id and name is set from previous interface
    var tourID: Int = 0
    var tourName: String = ""
    //URL link to api
    var url = URLNET+"getObjects.php"
    //Array of values recieved from database
    var ObjArray: NSMutableArray = NSMutableArray()
    //Array of hall id from selected halls is set from previous interface
    var hallsSelected : [String] = []
    //Array of object id from selected objects
    var ObjSelected : [String] = []
    //to selected all object in table
    var selectAll: Bool = false
    
    //Connection to table view on interface
    @IBOutlet weak var ObjTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ObjTable.dataSource = self
        ObjTable.delegate = self
        
        //function call to get objects from the database
        getObj()
    }
    
    func getObj(){
        //get each row in halls selected and get that hall id
        for row in 0..<hallsSelected.count{
            let hallID = hallsSelected[row]
            //set the selected hall id as parameter
            let parameter = ["id": hallID]
            
            //Almofire request to send hall id and retrieve object information from that hall from database by connecting to api and getting the echo response of SQL query
            Alamofire.request(url, method: .post, parameters: parameter).responseData(completionHandler: { (response) in
                
                if response.result.isSuccess {
                    let ObjJSON : JSON = JSON(response.data as Any)
                    print(ObjJSON)
                    
                    let lastRow = ObjJSON["objectdata"].count
                    //Loop through json object to get data and save it to array
                    for row in 0..<lastRow{
                        var ObjID = ObjJSON["objectdata"][row]["Object_id"].string!
                        var ARName = ObjJSON["objectdata"][row]["Name_AR"].string!
                        var EName = ObjJSON["objectdata"][row]["Name_E"].string!
                        var encodedImage = ObjJSON["objectdata"][row]["Picture"].string!
                        //Convert image text to data
                        let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                        
                        //If the language selected then save the arabia values
                        if isItArabic {
                            self.ObjArray.add(ObjsName.init(ObjID: ObjID, ObjName: ARName, ObjImg: imageData!))
                            //reload table to call function to  add the data into the table
                            self.reloadTable()
                        }else{
                           //else save english values
                            self.ObjArray.add(ObjsName.init(ObjID: ObjID, ObjName: EName, ObjImg: imageData!))
                            //reload table to call function to add the data into the table
                            self.reloadTable()
                        }
                    }
                } else {
                    //display error message on console if failure occurs
                    print("Error \(String(describing: response.result.error))")
                }
                
            })
        }
    }
    
    func reloadTable(){
        //reload table to call all functions for tableview and add the data into the table
        ObjTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create cell of prototype cell created on interface connecting to a class for that cell
        let cell = self.ObjTable.dequeueReusableCell(withIdentifier: "ObjCell", for: indexPath) as! PlanATour3TableViewCell
        //print("Set cells")
        
        //get row from array
        let ObjInfo = ObjArray[indexPath.row] as! ObjsName
        //set values into cell from array
        cell.ObjName.text = ObjInfo.ObjName
        cell.ObjImg.image = UIImage(data: ObjInfo.ObjImg)
        
        //if button "selected all" is tapped, then all object ids are added
        if selectAll {
            var id = ObjInfo.ObjID
            if !ObjSelected.contains(id){
                ObjSelected.append(id)
                print("Set button to cancel")
                cell.ObjSelect.image = UIImage(named: "cancel")
            }
        }
        
        //return that cell and display it
        return cell
    }
    
    //set number of rows function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count")
        return ObjArray.count
    }
    
    //return number of section in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //get information from selected row. called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create cell that is selected
        let cell = self.ObjTable.cellForRow(at: indexPath) as! PlanATour3TableViewCell
        print("&&&\(hallsSelected)")
        
        //get row from array that cooresponds the selected cell
        let ObjInfo = ObjArray[indexPath.row] as! ObjsName
        //get the object id from selected cell
        var id = ObjInfo.ObjID
        
        //if the id is in the array of selected values then remove it from array and change incon to indecate the row is no longer selected
        //else add it to array and change icon to indectae the row was added
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
        //reload table to show change in icons
        reloadTable()
        print("&&&\(ObjSelected)")
        
    }
    
    //set row height function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //called when next button is selected
    @IBAction func NextStep(_ sender: Any) {
        //if the object array list is empty and no objects are selected then an alert displys informing the user that they need to selected at least 1 object
        //else a segue is performed
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
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour4E"){
            let cv = segue.destination as! PlanATour4ViewController
            //Send tour id, tour name, halls selected, object selected to next interface
            cv.tourID = tourID
            cv.tourName = tourName
            cv.ObjSelected = ObjSelected
            cv.hallsSelected = hallsSelected
        }
    }
    
    //Function to set boolean if all objects are slected and reloads the table to call function to add objects to array
    @IBAction func SelectAllObjects(_ sender: Any) {
        if selectAll {
            selectAll = false
        } else {
            selectAll = true
        }
        reloadTable()
    }
    
    
    //Function to display an alert message
    func alertMessage(TitleOfMessage: String, Message: String, Okay: String){
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default, handler: nil)
        alertPrompt.addAction(confirmAction)
        present(alertPrompt, animated: true, completion: nil)
    }
}
