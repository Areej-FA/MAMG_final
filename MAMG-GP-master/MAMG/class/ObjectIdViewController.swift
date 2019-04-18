//
//  ObjectIdViewController.swift
//  MAMG
//
//  Created by Areej on 1/22/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ObjectIdViewController: UIViewController {

    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var Message: String = ""
    var TitleOfMessage: String = ""
    @IBOutlet weak var grCodeCamera: UIView!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self as! AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = grCodeCamera.layer.bounds
        grCodeCamera.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
            qrCodeFrameView.layer.borderWidth = 5
            
            grCodeCamera.addSubview(qrCodeFrameView)
            grCodeCamera.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String, isInDatabase: Bool) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: TitleOfMessage, message: Message, preferredStyle: .actionSheet)
        var confirmAction: UIAlertAction
        var cancelAction: UIAlertAction
        
        if isInDatabase {
            confirmAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                if isItArabic {
                    //TODO: check there are different AR and E interfaces
                    let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ObjectInfoAR") as! ObjectInfoViewController
                    cv.decodedURL = decodedURL
                    self.present(cv, animated: true, completion: nil)
                } else {
                    let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ObjectInfoE") as! ObjectInfoViewController
                    cv.decodedURL = decodedURL
                    self.present(cv, animated: true, completion: nil)
                }
                
                
            })
            
            cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
        } else {
            let cancelAction = UIAlertAction(title: "Try Again!", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(cancelAction)
        }
        
        present(alertPrompt, animated: true, completion: nil)
        
        
    }
    
    
    // Check if the QR code value is an object id or not
    
    func checkQRCode(grCode: String){
        
        let url: String = "http://192.168.64.2/dashboard/MyWebServices/api/getAnObject.php" //Link to PHP code in localHost
        
        var int: [String: String] = ["id":grCode]
        Alamofire.request(url, method: .post, parameters: int).responseJSON(completionHandler: {(response) in
            
            if response.result.isSuccess{
                print("Success! Got the object data")
                
                let ObjectJSON : JSON = JSON(response.data)
                
                if(ObjectJSON["Object_id"].stringValue == grCode){
                    
                    if isItArabic {
                        //TODO: translate
                        self.Message = ""
                        self.TitleOfMessage = ""
                    } else {
                        self.TitleOfMessage = "Found it"
                        self.Message = "Tap Yes to view the Object info."
                    }
                    self.launchApp(decodedURL: grCode, isInDatabase: true)
                    
                }else {
                    if isItArabic {
                        //TODO: translate
                        self.TitleOfMessage = ""
                        self.Message = ""
                    } else {
                        self.TitleOfMessage = "An error has occured"
                        self.Message = "QR code doesnt belong to Scitech"
                    }
                    self.launchApp(decodedURL: grCode, isInDatabase: false)
                    
                }
                
                
            }else{
                print("Error \(String(describing: response.result.error))")
            }
            
        })
    

    
     
    }
    
}

extension ObjectIdViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                checkQRCode(grCode: metadataObj.stringValue!)
                
            }
        }
    }
    
}



