//
//  SignUpViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    var message : String = ""
    //MARK: interface elements
    //MARK: text filed inputs
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var conformPasswordTextField: UITextField!
    
    //MARK: interface labels
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var firstNameLable: UILabel!
    @IBOutlet weak var lastNameLable: UILabel!
    @IBOutlet weak var mobileLable: UILabel!
    @IBOutlet weak var passwordLable: UILabel!
    @IBOutlet weak var conformPasswordLable: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    let DataURL: String = URLNET+"newUser.php" //Link to PHP code in localHost
    
    //MARK: Send POST request
    func dataToJson(url: String,id: [String: String]){
        Alamofire.request(url, method: .post, parameters: id).responseData { (response) in
            if response.result.isSuccess{
                print("Success! Got the object data")
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            emailLable.text = "Email"
            firstNameLable.text = "First Name"
            lastNameLable.text = "Last Name"
            mobileLable.text = "Mobile"
            passwordLable.text = "Password"
            conformPasswordLable.text = "Conform Password"
            signUpButton.setTitle("Sign Up", for: .normal)

        
    }
    
    // TODO: vad & var
    @IBAction func signUpButton(_ sender: Any) {
        if !chackIfEmpty() || !filedFormat()  {
            displayAlert(message: message)
        }else{
            let email = emailTextField.text
            let fname = firstNameTextField.text
            let lname = lastNameTextField.text
            let pass = passwordTextField.text
            let num = mobileTextField.text
            let user = ["Email": email , "First_name": fname   , "Last_name":lname, "Password" : pass , "Mobile" : num ];
            dataToJson(url: DataURL, id:  user as! [String : String] )
            displayAlert(message: "welcome " + fname!)
            usersEmaile = emailTextField.text!
            self.performSegue(withIdentifier: "fSignin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fSignin"){
            let hallInfoVC = segue.destination as! userProfileViewController
        }
    }
    
    //TODO: cases
    func chackFields(){
//        if !chackIfEmpty() || !filedFormat()  {
//            displayAlert(message: message)
//        }else{
//            let email = emailTextField.text
//            let fname = firstNameTextField.text
//            let lname = lastNameTextField.text
//            let pass = passwordTextField.text
//            let num = mobileTextField.text
//            let user = ["Email": email , "First_name": fname   , "Last_name":lname, "Password" : pass , "Mobile" : num ];
//            dataToJson(url: DataURL, id:  user as! [String : String] )
//            displayAlert(message: "welcome /(fname)")
//            usersEmaile = emailTextField.text!
//            self.performSegue(withIdentifier: "fSignup", sender: self)
//        }
    }
    

    
    //MARK: chack If  Fields are empty
    func chackIfEmpty()-> Bool{
        if (emailTextField.text == "" && firstNameTextField.text == "" && lastNameTextField.text == "" && mobileTextField.text == "" && passwordTextField.text == "" && conformPasswordTextField.text == "" && !isItArabic) {
            displayAlert(message: " All fields are empty ")
            print("it work")
            return false
        }else if (emailTextField.text == "" && firstNameTextField.text == "" && lastNameTextField.text == "" && mobileTextField.text == "" && passwordTextField.text == "" && conformPasswordTextField.text == "" && isItArabic){
            displayAlert(message: " جميع الخانات فارغة")
            return false
        }else if(emailTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" && mobileTextField.text != "" && passwordTextField.text != "" && conformPasswordTextField.text != "" ){
            return true
        }else{
            //MARK: email chack if empty
            if(emailTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the email field is empty \n")
            }else if(emailTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة البريد الالكتروني فارغة \n"
                )
            }
            //MARK: first Name chack if empty
            if(firstNameTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the first name field is empty \n")
            }else if(firstNameTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة الاسم الاول فارغة \n"
                )
            }
            //MARK: Last Name chack if empty
            if(lastNameTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the last name field is empty \n")
            }else if(lastNameTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة الاسم الاخير فارغة \n"
                )
            }
            //MARK: mobile chack if empty
            if(mobileTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the mobile field is empty \n")
            }else if(mobileTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة الرقم فارغة \n"
                )
            }
            //MARK: password chack if empty
            if(passwordTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the password field is empty \n")
            }else if(passwordTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة كلمة السر فارغة \n"
                )
            }
            //MARK:  conform password chack if empty
            if(conformPasswordTextField.text == "" && !isItArabic ){
                message.append(contentsOf: " the conform password field is empty \n")
            }else if(conformPasswordTextField.text == "" && isItArabic){
                message.append(contentsOf: "خانة تاكيد كلمة السر فارغة \n"
                )
            }
            return false
        }
    }
    
    //MARK: chack if the filed have the correct data
    func filedFormat() -> Bool {
        if (passwordTextField.text?.count)! >= 7{
            if passwordTextField.text != conformPasswordTextField.text {
                message.append(contentsOf: " passwords dont match \n")
                return false
            } else{
                if mobileTextField.text?.count == 10{
                    return true
                }else{
                    message.append(contentsOf: " mobile dont match \n")
                    return false
                }
            }
        }else {
            message.append(contentsOf: " passwords must be 8 characters \n")
            return false
        }
    }
    //MARK: Alert function
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
