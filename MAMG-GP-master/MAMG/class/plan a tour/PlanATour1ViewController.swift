//
//  PlanATour1ViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 25/02/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import SwiftyJSON

class PlanATour1ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //Connection to components on the GUI interface
    @IBOutlet weak var tourName: UITextField!
    @IBOutlet weak var tourDiscription: UITextField!
    @IBOutlet weak var imageBtn: UIButton!
    
    //To save tour id after inserting values in database
    var toursID: Int = 0
    //To save an image if selected
    var imageToUpload: UIImage!
    var imgToUp: UIImage!
    
    //Link to api file with php code
    let setPlannedTour = URLNET+"setPlannedTour.php"
    
    //Main function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //function called after a photo is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Got image")
        //Get selected imag
        imageToUpload = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //Resize selected image from custom propertiy from extension located at the bottom of this file
        imgToUp = imageToUpload.resized(withPercentage: 0.3)
        //set the selected image on the button
        imageBtn.setBackgroundImage(imgToUp, for: .normal)
        //Dismiss photo application
        dismiss(animated: true, completion: nil)
    }
    
    //An action function after the upload an image button in tapped
    @IBAction func UploadImage(_ sender: Any) {
        //Open photo library application to select an image
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

    //An action function after next button is tapped
    @IBAction func uploadPlannedTour(_ sender: Any) {
        //Checks is the name and description fields are empty or not
        if tourName.text!.isEmpty && tourDiscription.text!.isEmpty {
            //if it is empty then display an alert
            if isItArabic{
                //TODO: Translate
                //alertMessage(TitleOfMessage: <#T##String#>, Message: <#T##String#>, Okay: <#T##String#>)
            } else {
                alertMessage(TitleOfMessage: "Required", Message: "Name and Describtione are required", Okay: "OK")
            }
            
        } else {
            //else set the image name, parameters, tour name and decription
            var imgInData: Data = Data()
            var parameters: Parameters
            var imgName = "file"
            
            var nameT = tourName.text!
            var descT = tourDiscription.text!
            
            //set name and descrption as parameters to send to database
            parameters = ["Name" : nameT, "Descrption" : descT]
            
            //check if there is an image to be sent or not
            if imgToUp != nil {
                //If there is an image, then send to function with action to upload image
                print("upload with img")
                imgInData = imgToUp.jpegData(compressionQuality: 0.1)!
                uploadToDB(imgInData, parameters, imgName)
                
            } else {
                //else send to function that just sends text data
                print("upload without img")
                uploadNoImg(parameters)
            }
            
            
        }
    }
    
    //Function that send text with image
    func uploadToDB(_ imgInData: Data,_ parameters: Parameters,_ imgName: String){
        
        print("\n\nImg\n\n")
        //Alamofire type that sends image to api
        Alamofire.upload(multipartFormData: { multipartFormData in
            //add parameter to variable
            for (key,value) in parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            //add image to the same variable
            multipartFormData.append(imgInData, withName: imgName, fileName: imgName+".jpeg",mimeType: "image/jpeg")
        }, to: setPlannedTour, method: .post, encodingCompletion: { encodingResult in // to: the url link to api, method POST php request type
            //result from api file
            switch encodingResult {
                //If the upload is success or a failure
            case .success(let upload, _, _):
                upload.responseString { response in
                    let ObjectJSON : JSON = JSON(response.data)
                    //gets tour id after the inserted data that was just sent
                    self.toursID = ObjectJSON["Tour_id"].int!
                    //to function which navigates to next interface (Plan A Tour 2)
                    self.performSegue(withIdentifier: "PlanATour2E", sender: self)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    //Function to send text only
    func uploadNoImg(_ parameters: Parameters){
        print("\n\nNo img\n\n")
        //Alamorfire request without sending image data
        Alamofire.request(setPlannedTour, method: .post, parameters: parameters).responseData { (response) in
            
            if response.result.isSuccess{
                print("Success! Got the object data")
                let ObjectJSON : JSON = JSON(response.data)
                //gets tour id after the inserted data that was just sent
                self.toursID = ObjectJSON["Tour_id"].int!
                //to function which navigates to next interface (Plan A Tour 2)
                self.performSegue(withIdentifier: "PlanATour2E", sender: self)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    //Function to navigate(perform segue) to interface
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour2E"){
            let cv = segue.destination as! PlanATour2ViewController
            //sends tour id and name to next interface
            cv.tourID = toursID
            cv.tourName = tourName.text!
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

//Create a custum property extension to UIImage type variable
extension UIImage {
    //Property to resize image using percentage
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    //Property to resize image using float point
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

