//
//  BookmarkViewController.swift
//  MAMG
//
//  Created by Sarah Al-Matawah on 27/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct BookmarkList{
    var ObjID: String
    var ObjName: String
    var ObjImg: String
    var selectedObject: Bool = false
    
    init(ObjID: String, ObjName: String, ObjImg: String) {
        self.ObjID = ObjID
        self.ObjName = ObjName
        self.ObjImg = ObjImg
    }
}

class BookmarkViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var bookmarkCollectionView: UICollectionView!
    
    let UrlBookmark = URLNET + "getBookmark.php"
    var bookmark: NSMutableArray = NSMutableArray();
    var objectID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bookmark"

        bookmarkCollectionView!.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        getObjects()
    }
    
    func getObjects(){
        if !usersEmaile.isEmpty {
            let par = ["email":usersEmaile]
            Alamofire.request(UrlBookmark, method: .post, parameters: par).responseData(completionHandler: { (response) in
                if response.result.isSuccess {
                    let bookmarkJSON : JSON = JSON(response.data)
                    for row in 0...bookmarkJSON.count {
                        let objID = bookmarkJSON["objectdata"][row]["Object_id"].stringValue
                        var name = ""
                        if isItArabic {
                            name = bookmarkJSON["objectdata"][row]["Name_AR"].stringValue
                        } else {
                            name = bookmarkJSON["objectdata"][row]["Name_E"].stringValue
                        }
                        
                        let image = bookmarkJSON["objectdata"][row]["Picture"].stringValue
                        
                        self.bookmark.add(BookmarkList.init(ObjID: objID, ObjName: name, ObjImg: image))
                    }
                    
                    self.bookmarkCollectionView.reloadData()
                } else {
                    print("Error \(String(describing: response.result.error))")
                }
            })
        }
    }
    
    // //number of columns
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bookmark.count)
    }
    //fill controles with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        
        let bookmarkObj = bookmark[indexPath.row] as! BookmarkList
        
        let hallImage = cell.viewWithTag(1) as! UIImageView
        let hallName = cell.viewWithTag(2) as! UILabel
        
        hallName.text = bookmarkObj.ObjName
        
        if let imageData = Data(base64Encoded: bookmarkObj.ObjImg) {
            hallImage.image = UIImage(data: imageData)
        }
        return cell
    }
    // to know wich row was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookmarkObj = bookmark[indexPath.row] as! BookmarkList
        objectID = bookmarkObj.ObjID
        self.performSegue(withIdentifier: "bookmarkObj", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "bookmarkObj"){
            let objectVC = segue.destination as! ObjectInfoViewController
            objectVC.decodedURL = self.objectID
        }
    }

    

}
