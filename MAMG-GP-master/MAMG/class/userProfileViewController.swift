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
    
    let DataURL: String = URLNET + "userProfile.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(usersEmaile)")
        let user = ["Email": usersEmaile ];
        dataToJson(url: DataURL, id:  user )
    }
    
    //get users info
    func dataToJson(url: String,id: [String: String]){
        Alamofire.request(url, method: .post, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                let weatherJSON : JSON = JSON( response.result.value! )
                self.updateWeatherData(json: weatherJSON)
                print(weatherJSON)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    @IBAction func wishlist(_ sender: Any) {
        self.performSegue(withIdentifier: "whishlit", sender: self)
    }
    
    //setting users info
    func updateWeatherData (json : JSON){
        let email = json["Email"].stringValue
        let fname = json["First_name"].stringValue
        let lname = json["Last_name"].stringValue
        let mobile = json["Mobile"].stringValue
        let name = "\(fname) \(lname)"
        nameLable.text = name
        emailLable.text = email
        mobileLable.text = mobile
    }
    
    @IBAction func SignOut(_ sender: Any) {
        //remove email and set guest to true when loggin out
        usersEmaile = ""
        isUserAGust = true
        self.performSegue(withIdentifier: "logoutE", sender: self)
    }
    
    @IBAction func history(_ sender: Any) {
        self.performSegue(withIdentifier: "history", sender: self)
    }
    
    @IBAction func bookmark(_ sender: Any) {
        self.performSegue(withIdentifier: "bookmark", sender: self)
    }
    
    //From naviagtion to other interfaces
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "logoutE"){
            //to logout and return to login interface
            let lgout = segue.destination as! LoginViewController
        }
        if(segue.identifier == "whishlit"){
            //to wishlist interface
            let wishlist = segue.destination as! WishlistViewController
        }
        if(segue.identifier == "history"){
            //to tour history interface
            let history = segue.destination as! ToursHistoryViewController
        }
        if(segue.identifier == "bookmark"){
            //to bookmark interface
            let bookmark = segue.destination as! BookmarkViewController
        }
    }
    

}
