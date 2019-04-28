//
//  EventViewController.swift
//  MAMG
//
//  Created by Areej on 1/22/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MIDITimeTableView

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventsList = [EventBean]()
    var event = EventBean()
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
    }
    
    //Function to get events from database
    func getEvents() {
        let myURL = URLNET+"getEvents.php"
        eventsList = [EventBean]()
        
        Alamofire.request(myURL, method: .get, parameters: nil).responseJSON{
            response in
            
            switch(response.result){
                
            case .success:
                
                let json = JSON(response.data!)
                
                let array = json["product"].arrayValue
                
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    
                    let object = EventBean()
                    
                    object.Event_id = dic["Event_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Name_AR = dic["Name_AR"].stringValue
                    object.Start_date = dic["Start_date"].stringValue
                    object.End_date = dic["End_date"].stringValue
                    object.Picture = dic["Picture"].stringValue
                    
                    var activitiesList = [EventActivityBean]()
                    
                    if let activitiesArray = dic["activities"].arrayValue as? NSArray{
                        
                        for j in 0..<activitiesArray.count {
                            let activitiesDic = JSON(activitiesArray[j])
                            let obj = EventActivityBean()
                            
                            obj.Activity_id = activitiesDic["Activity_id"].stringValue
                            obj.Time = activitiesDic["Time"].stringValue
                            obj.Ticket_Price = activitiesDic["Ticket_Price"].stringValue
                            obj.Age_Group = activitiesDic["Age_Group"].stringValue
                            activitiesList.append(obj)
                        }
                        object.activities = activitiesList
                    }
                    if (self.eventsList.count) == nil{
                        let alertController = UIAlertController(title: nil, message: "This is No Events", preferredStyle: .alert)
                        
                        let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                            print("You've pressed the destructive");
                        }
                        
                        alertController.addAction(action3)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    self.eventsList.append(object)
                }
                
                self.eventsTableView.reloadData()
                break
                
            case .failure:
                break
            }
        }
    }
    
    // number of columns
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventsList.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // to fill the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let eventImage = cell.viewWithTag(1) as! UIImageView
        let eventName = cell.viewWithTag(2) as! UILabel
        
        if(isItArabic){
            eventName.text = eventsList[indexPath.row].Name_AR
        }else{
            eventName.text = eventsList[indexPath.row].Name_E
        }
        
        if let imageData = Data(base64Encoded: eventsList[indexPath.row].Picture) {
            eventImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    //Function to get tour if from selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        event = eventsList[indexPath.row]
        self.performSegue(withIdentifier: "eventInfo", sender: self)
    }
   
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "eventInfo"){
            let eventVC = segue.destination as! EventInfoViewController
            eventVC.event = self.event
        }
    }
    
//connectiong to table view in interface
    @IBOutlet weak var Test: MIDITimeTableView!

}
