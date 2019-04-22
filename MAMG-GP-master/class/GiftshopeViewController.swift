import UIKit
import Alamofire
import SwiftyJSON

class GiftshopeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{


    @IBOutlet weak var giftsCollectionView: UICollectionView!
    
    var giftsList = [GiftBean]()
    var gift = GiftBean()

    
    override func viewDidLoad() {
        super.viewDidLoad()


        giftsList = [GiftBean]()
        // to check if it is gust or user
        if(isUserAGust  == true)
        {
            let alertController = UIAlertController(title: nil, message: "Sorry, you must be logged in", preferredStyle: .alert)
            
            let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed the destructive");
            }
            
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }else{
            getGifts()
        }
        
        
    }
    
    func getGifts() {
         // url for api
        let myURL = URLNET + "getGifts.php"
        giftsList.removeAll()
        let params : Parameters = ["Email":usersEmaile]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){
                // case successed
            case .success:
                print(response.value!)
                // to parse json data
                let json = JSON.init(parseJSON: response.value!)
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    let object = GiftBean()
                    object.Pro_id = dic["Pro_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Name_Ar = dic["Name_Ar"].stringValue
                    object.Picture = dic["Picture"].stringValue
                    object.Price = dic["Price"].stringValue
                    object.Quantity = dic["Quantity"].stringValue
                    object.Description_E = dic["Description_E"].stringValue
                    object.Description_Ar = dic["Description_Ar"].stringValue
                    object.Typee = dic["Type"].stringValue
                    object.product_fav = dic["product_fav"].intValue
                
                    self.giftsList.append(object)
                }
                if (self.giftsList.count < 1) {
                    let alertController = UIAlertController(title: nil, message: "This are No Gifts", preferredStyle: .alert)
                    
                    let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                    }
                    
                    alertController.addAction(action3)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.giftsCollectionView.reloadData()
                break
                
            case .failure:
                print(response.description)
                break
            }
        }
    }
    
    func getScience(){
        print("SCIENCE")
        giftsList.removeAll()
        giftsCollectionView.reloadData()
    }
    
    func getWishlist(){
        print("WISHLIST")
        giftsList.removeAll()
        giftsCollectionView.reloadData()
    }
    // number of columns
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (giftsList.count)
    }
    // to fill control with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        
        let giftImage = cell.viewWithTag(1) as! UIImageView
        let giftName = cell.viewWithTag(2) as! UILabel
        
        if(isItArabic){
            giftName.text = giftsList[indexPath.row].Name_Ar
        }else{
            giftName.text = giftsList[indexPath.row].Name_E
        }
        
        if let imageData = Data(base64Encoded: giftsList[indexPath.row].Picture) {
            giftImage.image = UIImage(data: imageData)
        }
        return cell
    }
    // to retrive wich row was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gift = giftsList[indexPath.row]
        self.performSegue(withIdentifier: "giftInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "giftInfo"){
            let giftInfoVC = segue.destination as! GiftInfoViewController
            giftInfoVC.gift = self.gift
        }
    }
    
    

}
