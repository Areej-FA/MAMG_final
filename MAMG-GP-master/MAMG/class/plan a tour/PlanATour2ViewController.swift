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

//Structure model for hall object
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
   
    //Tour is set from previous interface
    var tourID: Int = 0
    //URL link to api
    var url = URLNET+"returnHalls.php"
    //Array of values recieved from database
    var nameArray: NSMutableArray = NSMutableArray()
    //Array of hall id from selected halls
    var hallsSelected : [String] = []
    //is set from previous interface
    var tourName: String = ""
    
    //Connection to table view on interface
    @IBOutlet weak var tableHalls: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableHalls.dataSource = self
        tableHalls.delegate = self
        
        //function call to get halls from the database
        getHalls()
    }
    
    //Function to get hall information from database
    func getHalls(){
        //Almofire request to retrieve hall information from database by connecting to api and getting the echo response of SQL query
        Alamofire.request(url, method: .post).responseData { (response) in
            if response.result.isSuccess{
                let ObjJSON : JSON = JSON(response.data)
                print(ObjJSON)
                
                let lastRow = ObjJSON["objectdata"].count
                print(lastRow)
                //Loop through json object to get data and save it to array
                for row in 0..<lastRow{
                    var hallID = ObjJSON["objectdata"][row]["Hall_id"].string!
                    var ARName = ObjJSON["objectdata"][row]["Name_AR"].string!
                    var EName = ObjJSON["objectdata"][row]["Name_E"].string!
                    var encodedImage = ObjJSON["objectdata"][row]["Picture"].stringValue
                    print("\(row) : \(EName)")
                    //Convert image text to data
                    let imageData = Data(base64Encoded: encodedImage, options: NSData.Base64DecodingOptions(rawValue: 0))
                    print("*****Img Data : \(imageData!)")
                    //If the language selected then save the arabia values
                    if isItArabic {
                        self.nameArray.add(HallsName.init(HallID: hallID, Name: ARName, UriName: imageData!))
                        //reload table to call function to  add the data into the table
                        self.reloadTable()
                    }else{
                       //else save english values
                        self.nameArray.add(HallsName.init(HallID: hallID, Name: EName, UriName: imageData!))
                        //reload table to call function to add the data into the table
                        self.reloadTable()
                    }
                }
            }else{
                //display error message on console if failure occurs
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    func reloadTable(){
        //reload table to call all functions for tableview and add the data into the table
        tableHalls.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create cell of prototype cell created on interface connecting to a class for that cell
        let cell = self.tableHalls.dequeueReusableCell(withIdentifier: "HallCell", for: indexPath) as! PlanATour2TableCellViewController
        //print("Set cells")
        
        //get row from array
        let HallNames = nameArray[indexPath.row] as! HallsName
        //set values into cell from array
        cell.ObjName.text = HallNames.Name
        cell.ObjImg.image = UIImage(data: HallNames.UriName)
        //return that cell and display it
        return cell
    }
    
    //set row height function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //set number of rows function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count")
        return nameArray.count
    }
    
    //return number of section in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //get information from selected row. called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create cell that is selected
        let cell = self.tableHalls.cellForRow(at: indexPath) as! PlanATour2TableCellViewController
        
        //get row from array that cooresponds the selected cell
        let HallNames = nameArray[indexPath.row] as! HallsName
        //get the hall id from selected cell
        var id = HallNames.HallID
        //if the id is in the array of selected values then remove it from array and change incon to indecate the row is no longer selected
        //else add it to array and change icon to indectae the row was added
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
        //reload table to show change in icons
        reloadTable()
        print("&&&\(hallsSelected)")
        
    }
    
    //called when next button is selected
    @IBAction func NextStep(_ sender: Any) {
        //if the hall array list is empty and no halls are selected then an alert displys informing the user that they need to selected at least 1 hall
        //else a segue is performed
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
    
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour3E"){
            let cv = segue.destination as! PlanATour3ViewController
            //Send tour id, tour name, halls selected to next interface
            cv.tourID = tourID
            cv.tourName = tourName
            cv.hallsSelected = hallsSelected
        }
    }
    
    
    //Function to display an alert message
    func alertMessage(TitleOfMessage: String, Message: String, Okay: String){
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default, handler: nil)
        alertPrompt.addAction(confirmAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }

}
