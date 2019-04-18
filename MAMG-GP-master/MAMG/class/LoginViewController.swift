//
//  LoginViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    //MARK: this the interface elements
    @IBOutlet var emailTextfield_E: UITextField!
    @IBOutlet var passwordTextfield_E: UITextField!
    
    @IBOutlet var emailTextfield_Ar: UITextField!
    @IBOutlet var passwordTextfield_Ar: UITextField!
    
    let DataURL: String = "http://192.168.64.2/dashboard/MyWebServices/api/login.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Send POST request
    func dataToJson(url: String,id: [String: String]){
        Alamofire.request(url, method: .post, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                print("Success! Got the object data")
                let weatherJSON : JSON = JSON( response.result.value! )
                print(weatherJSON)
                usersEmaile = weatherJSON[0]["Email"].stringValue
                print(usersEmaile)
                if(usersEmaile == ""){
                    self.displayAlert(message: "email or password dont match");
                }
                
            }else{
                print("Error \(String(describing: response.result.error))")
                
            }
            
        }
        
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if isItArabic {
            if (emailTextfield_Ar.text == "" || passwordTextfield_Ar.text == ""){
                displayAlert(message: "  لا يمكن ان تكون الخانات فارغة");
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile") as! userProfileViewController
                self.present(cv, animated: true, completion: nil)
                usersEmaile = emailTextfield_Ar.text!
            }else{
                let email = emailTextfield_Ar.text
                let pass = passwordTextfield_Ar.text
                let user = ["Email": email ,  "Password" : pass ];
                dataToJson(url: DataURL, id:  user as! [String : String] )
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profile") as! userProfileViewController
                self.present(cv, animated: true, completion: nil)
                usersEmaile = emailTextfield_E.text!
            }
        }
        else{
            if (emailTextfield_Ar.text == "" || passwordTextfield_Ar.text == ""){
                displayAlert(message: "fileds must be filled");
            }else{
                let email = emailTextfield_E.text
                let pass = passwordTextfield_E.text
                let user = ["Email": email ,  "Password" : pass ];
                dataToJson(url: DataURL, id:  user as! [String : String] )
            }
            
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        
    }
    func displayAlert(message: String){
        if (isItArabic) {
            let alert = UIAlertController(title: "تنبيه", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "حسنا", style: .default , handler:
                nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }else if(!isItArabic){
            let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ok", style: .default , handler:
                nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

}
