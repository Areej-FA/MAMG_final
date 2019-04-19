//
//  userProfileViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class userProfileViewController: UIViewController {

    @IBOutlet weak internal var nameLable: UILabel!
    @IBOutlet weak internal var emailLable: UILabel!
    @IBOutlet weak internal var mobileLable: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    let DataURL: String = "http://192.168.64.2/dashboard/MyWebServices/api/userProfile.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = ["Email": usersEmaile ];
        dataToJson(url: DataURL, id:  user )
    }
    
    func dataToJson(url: String,id: [String: String]){
        Alamofire.request(url, method: .post, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                let weatherJSON : JSON = JSON( response.result.value! )
                self.updateWeatherData(json: weatherJSON)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateWeatherData (json : JSON){
        let email = json[0]["Email"].stringValue
        let fname = json[0]["First_name"].stringValue
        let lname = json[0]["Last_name"].stringValue
        let mobile = json[0]["Mobile"].stringValue
        let name = "\(fname) \(lname)"
        nameLable.text = name
        emailLable.text = email
        mobileLable.text = mobile
    }

}
