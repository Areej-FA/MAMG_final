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

    @IBOutlet weak var tourName: UITextField!
    @IBOutlet weak var tourDiscription: UITextField!
    @IBOutlet weak var imageBtn: UIButton!
    
    
    var tourN: String = ""
    var toursID: Int = 0
    
    var imageToUpload: UIImage!
    var imgToUp: UIImage!
    
    let setPlannedTour = URLNET+"setPlannedTour.php"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if tourN != "" {
            tourName.text = tourN
        }
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Got image")
        imageToUpload = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgToUp = imageToUpload.resized(withPercentage: 0.3)
        imageBtn.setBackgroundImage(imgToUp, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func UploadImage(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

    @IBAction func uploadPlannedTour(_ sender: Any) {
        
        if tourName.text!.isEmpty && tourDiscription.text!.isEmpty {
            if isItArabic{
                //TODO: Translate
                //alertMessage(TitleOfMessage: <#T##String#>, Message: <#T##String#>, Okay: <#T##String#>)
            } else {
                alertMessage(TitleOfMessage: "Required", Message: "Name and Describtione are required", Okay: "OK")
            }
            
        } else {
            var imgInData: Data = Data()
            var parameters: Parameters
            var imgName = "file"
            
            var nameT = tourName.text!
            var descT = tourDiscription.text!
            
            parameters = ["Name" : nameT, "Descrption" : descT]
            
            if imgToUp != nil {
                print("upload with img")
                imgInData = imgToUp.jpegData(compressionQuality: 0.1)!
                uploadToDB(imgInData, parameters, imgName)
                
            } else {
                print("upload without img")
                uploadNoImg(parameters)
            }
            
            
        }
    }
    
    func uploadToDB(_ imgInData: Data,_ parameters: Parameters,_ imgName: String){
        
        print("\n\nImg\n\n")
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key,value) in parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            
            multipartFormData.append(imgInData, withName: imgName, fileName: imgName+".jpeg",mimeType: "image/jpeg")
        }, to: setPlannedTour, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    let ObjectJSON : JSON = JSON(response.data)
                    self.toursID = ObjectJSON["Tour_id"].int!
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    func uploadNoImg(_ parameters: Parameters){
        print("\n\nNo img\n\n")
        Alamofire.request(setPlannedTour, method: .post, parameters: parameters).responseData { (response) in
            
            if response.result.isSuccess{
                print("Success! Got the object data")
                let ObjectJSON : JSON = JSON(response.data)
                self.toursID = ObjectJSON["Tour_id"].int!
                self.performSegue(withIdentifier: "PlanATour2E", sender: self)
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PlanATour2E"){
            let cv = segue.destination as! PlanATour2ViewController
            cv.tourID = toursID
            cv.tourName = tourName.text!
        }
    }
    
    func alertMessage(TitleOfMessage: String, Message: String, Okay: String){
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default, handler: nil)
        alertPrompt.addAction(confirmAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }

}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

