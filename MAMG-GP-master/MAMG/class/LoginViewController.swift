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
    
    let DataURL: String = "http://http://192.168.64.2/dashboard/MyWebServices/api/login.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Send POST request
    func dataToJson(url: String,id: [String: String]){
        Alamofire.request(url, method: .get, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                print("Success! ")
//                let weatherJSON : JSON = JSON( response.result.value! )
            }else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
            if (emailTextfield_E.text == "" || passwordTextfield_E.text == ""){
                displayAlert(message: "fileds must be filled");
            }else{
                let email = emailTextfield_E.text
                let pass = passwordTextfield_E.text
                 usersEmaile = emailTextfield_E.text!
                let user = ["Email": email ,  "Password" : pass ];
                dataToJson(url: DataURL, id:  user as! [String : String] )
                let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileE") as! userProfileViewController
                self.present(cv, animated: true, completion: nil)
               self.performSegue(withIdentifier: "fLogin", sender: self)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fLogin"){
            let hallInfoVC = segue.destination as! userProfileViewController
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
