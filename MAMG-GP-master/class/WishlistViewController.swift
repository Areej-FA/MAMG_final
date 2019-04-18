import UIKit
import Alamofire
import SwiftyJSON

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var wishlistTableView: UITableView!
    var wishList = [WishlistBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// to check if it aguest or user
        if(isUserAGust == true)
        {
            // show message to guest
            let alertController = UIAlertController(title: nil, message: "Sorry for only registed user", preferredStyle: .alert)
            
            let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed the destructive");
            }
            
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }else{
       
             getWishlist()
        }
       
    }

    func getWishlist() {
        // url for api
        let myURL = "http://" + networkIP + "/magazin/MyWebServices/api/getUserWishList.php"
        wishList.removeAll()
        
        let params : Parameters = ["Email":usersEmaile]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){
                // if successed
            case .success:
                print(response.value!)
                let json = JSON.init(parseJSON: response.value!)
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    let object = WishlistBean()
                    object.Pro_id = dic["Pro_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Name_Ar = dic["Name_Ar"].stringValue
                    object.Picture = dic["Picture"].stringValue
                    self.wishList.append(object)
                }
                if (self.wishList.count) == 0{
                    let alertController = UIAlertController(title: nil, message: "This is No WishList for this user", preferredStyle: .alert)
                    
                    let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                    }
                    
                    alertController.addAction(action3)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.wishlistTableView.reloadData()
                break
                
            case .failure:
                print(response.description)
                break
            }
        }
    }
    // number of columns
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (wishList.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    // to fill controles with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let wishImage = cell.viewWithTag(1) as! UIImageView
        let wishName = cell.viewWithTag(2) as! UILabel
        
        
        if(isItArabic){
            wishName.text = wishList[indexPath.row].Name_Ar
        }else{
            wishName.text = wishList[indexPath.row].Name_E
        }
        if let imageData = Data(base64Encoded: wishList[indexPath.row].Picture) {
            wishImage.image = UIImage(data: imageData)
        }
        
        return cell
    }
    // to edit the cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            deleteFromWishlist(index: indexPath)
        }
    }
    // to moc=ve the cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // to delete an row
    func deleteFromWishlist(index: IndexPath) {
        let myURL = "http://" + networkIP + "/magazin/MyWebServices/api/deleteWishlist.php"

        let pro_id = wishList[index.row].Pro_id
        let params : Parameters = ["Pro_id":pro_id, "Email":usersEmaile]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){

            case .success:
                self.wishList.remove(at: index.row)
                self.wishlistTableView.deleteRows(at: [index], with: .fade)
                break

            case .failure:
                print(response.description)
                break
            }
        }
    }
}
