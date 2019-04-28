//
//  VolunteersViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VolunteersViewController: UIViewController {

    //MARK:
    let DataURL: String = URLNET+"addVolunteer.php"
    var message : String = ""
    var gender : String = ""
    var peroid : String = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nationalityTextFiled: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var qualificationTextField: UITextField!
    
    @IBOutlet weak var periodSegment: UISegmentedControl!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiLangage()
    }
    
    //MARK: Send POST request
    func dataToJson(url: String,data: [String: String]){
        Alamofire.request(url, method: .post, parameters: data).responseData { (response) in
            if response.result.isSuccess{
                let dataJSON : JSON = JSON( response.result.value! )
                print(dataJSON)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //get data from fields to send an email and insert them into database
    @IBAction func sendForm(_ sender: Any) {
        print("hello")
        if chackFields() {
            let name = nameTextField.text
            let nationality = nationalityTextFiled.text
            let age = ageTextField.text
            let email = emailTextField.text
            let phone = phoneTextField.text
            let qualifications = qualificationTextField.text
            
            if isItArabic {
                switch periodSegment.selectedSegmentIndex{
                case 2:
                    peroid = "الفترة الصباحية"
                    break
                case 1:
                    peroid = "الفترة المسائية"
                    break
                case 0:
                    peroid = "الفترتين"
                    break
                default:
                    print("Error no index selected")
                }
                switch genderSegment.selectedSegmentIndex{
                case 1:
                    gender = " ذكر"
                    break
                case 0:
                    gender = "انثى"
                    break
                default:
                    print("Error no index selected")
                }
            }else{
                switch periodSegment.selectedSegmentIndex{
                case 2:
                    peroid = "Both"
                    break
                case 1:
                    peroid = "Evening"
                    break
                case 0:
                    peroid = "Morning"
                    break
                default:
                    print("Error no index selected")
                }
                
                switch genderSegment.selectedSegmentIndex{
                case 1:
                    gender = "Male"
                    break
                case 0:
                    gender = "Female"
                    break
                default:
                    print("Error no index selected")
                }
            }
            
            let volunteer = ["Name": name , "mobile" : phone ,"Email" : email ,"Nationality": nationality ,  "Age" : age , "Gender" : gender ,  "Period" : peroid, "Qualification" : qualifications ]
            
            dataToJson(url: DataURL,data: volunteer as! [String : String])
            displayAlert(message: "your reqest sent sccussfly")
        }else{
            displayAlert(message: message)
        }
    }
    
    func chackFields() -> Bool {
        if (nameTextField.text != "" && nationalityTextFiled.text != "" && ageTextField.text != "" && emailTextField.text != "" && phoneTextField.text != "" && qualificationTextField.text != "") {
            if (phoneTextField.text!.count == 10 && isNumber(textField: phoneTextField) && isNumber(textField: ageTextField)){
                return true
            }
        }
        if (nameTextField.text == "" && nationalityTextFiled.text == "" && ageTextField.text == "" && emailTextField.text == "" && phoneTextField.text == "" && qualificationTextField.text == "") {
            if(isItArabic){
                displayAlert(message: " جميع الخانات فارغة")
            }else{
                displayAlert(message: " All fields are empty ")
            }
            
        }else{
            if(nameTextField.text == ""){
                if(isItArabic){
                    message.append(contentsOf: "خانة الاسم فارغة")
                }else{
                    message.append(contentsOf: " the name field is empty \n")
                }
                
            }
            
            if(nationalityTextFiled.text == ""){
                if(isItArabic){
                    message.append(contentsOf: "خانة الجنسية فارغة")
                }else{
                    message.append(contentsOf: " the nationality field is empty \n")
                }
                
            }
            
            if(ageTextField.text == ""){
                if(isItArabic){
                    message.append(contentsOf: "خانة العمر فارغة")
                }else{
                    message.append(contentsOf: " the age field is empty \n")
                }
                
            }else{
                if(!isNumber(textField: ageTextField)){
                    if(isItArabic){
                        message.append(contentsOf: " العمر يجب ان يكون رقم")
                    }else{
                        message.append(contentsOf: " the age field must be a number \n")
                    }
                }
                
            }
            
            if(emailTextField.text == ""){
                if(isItArabic){
                    message.append(contentsOf: "خانة البريد الالكتروني  فارغة")
                }else{
                    message.append(contentsOf: " the email field is empty \n")
                }
                return false
            }
            
            
            if(phoneTextField.text == ""){
                if(isItArabic){
                    message.append(contentsOf: "خانة الجوال  فارغة")
                }else{
                    message.append(contentsOf: " the phone field is empty \n")
                }
                return false
            }else{
                if(!isNumber(textField: phoneTextField)){
                    if(isItArabic){
                        message.append(contentsOf: " الجوال يجب ان يكون رقم")
                    }else{
                        message.append(contentsOf: " the phone field must be a number \n")
                    }
                    return false
                }
                if(phoneTextField.text!.count != 10){
                    if(isItArabic){
                        message.append(contentsOf: " الجوال يجب ان يكون متكون من ١٠ خانات")
                    }else{
                        message.append(contentsOf: " the phone filed must be 10 digits \n")
                    }
                    return false
                }
                
                if(qualificationTextField.text == ""){
                    if(isItArabic){
                        message.append(contentsOf: "خانة المؤهل  فارغة")
                    }else{
                        message.append(contentsOf: " the qualification field is empty \n")
                    }
                    
                }
            }
        }
        
        return false
    }
    
    func isNumber(textField: UITextField) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: textField.text!)
        return allowedCharacters.isSuperset(of: characterSet)
        //        return true
    }
    
    
    //MARK
    func uiLangage(){
        if (isItArabic) {
            nameTextField.placeholder = "الاسم"
            nameTextField.textAlignment = NSTextAlignment.right
            nationalityTextFiled.placeholder = "الجنسية"
            nationalityTextFiled.textAlignment = NSTextAlignment.right
            ageTextField.placeholder =  "العمر"
            ageTextField.textAlignment = NSTextAlignment.right
            emailTextField.placeholder = "البريد الالكتروني"
            emailTextField.textAlignment = NSTextAlignment.right
            phoneTextField.placeholder = " الجوال"
            phoneTextField.textAlignment = NSTextAlignment.right
            qualificationTextField.placeholder = "المؤهل"
            qualificationTextField.textAlignment = NSTextAlignment.right
            periodSegment.setTitle(" الفترة الصباحية", forSegmentAt: 2)
            periodSegment.setTitle(" الفترة المسائية", forSegmentAt: 1)
            periodSegment.setTitle("الفترتين", forSegmentAt: 0)
            genderSegment.setTitle("ذكر", forSegmentAt: 1)
            genderSegment.setTitle("انثى", forSegmentAt: 0)
            sendButton.setTitle(" ارسل", for: .normal)
        }else{
            nameTextField.placeholder = "Name"
            nameTextField.textAlignment = NSTextAlignment.left
            nationalityTextFiled.placeholder = "Nationality"
            nationalityTextFiled.textAlignment = NSTextAlignment.left
            ageTextField.placeholder =  "Age"
            ageTextField.textAlignment = NSTextAlignment.left
            emailTextField.placeholder = "Email"
            emailTextField.textAlignment = NSTextAlignment.left
            phoneTextField.placeholder = "Phone"
            phoneTextField.textAlignment = NSTextAlignment.left
            qualificationTextField.placeholder = "Qualification"
            qualificationTextField.textAlignment = NSTextAlignment.left
            periodSegment.setTitle("Both", forSegmentAt: 2)
            periodSegment.setTitle("Evening", forSegmentAt: 1)
            periodSegment.setTitle("Morning", forSegmentAt: 0)
            genderSegment.setTitle("Male", forSegmentAt: 1)
            genderSegment.setTitle("Female", forSegmentAt: 0)
            sendButton.setTitle("send", for: .normal)
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
