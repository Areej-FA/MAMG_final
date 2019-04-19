import UIKit
import Alamofire

class GiftInfoViewController: UIViewController {

    var gift = GiftBean()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftDescription: UITextView!
    @IBOutlet weak var giftPrice: UILabel!
    @IBOutlet weak var giftFav: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backView.layer.cornerRadius = 15
        if let imageData = Data(base64Encoded: (gift.Picture)) {
            giftImage.image = UIImage(data: imageData)
        }
        // to check if the interface is arabic or english
        if(isItArabic){
            self.title = gift.Name_Ar
            giftName.text = gift.Name_Ar
            giftDescription.text = gift.Description_Ar
            giftPrice.text = (gift.Price) + " ر.س "
        }else{
            self.title = gift.Name_E
            giftName.text = gift.Name_E
            giftDescription.text = gift.Description_E
            giftPrice.text = (gift.Price) + " S.R "
        }
        // to check if the user has afavorite for same product
        if((gift.product_fav) == 0){
            giftFav.setImage(UIImage.init(named: "like-1")!.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    // to insert product wishlist in database
    @IBAction func addToFav(_ sender: Any) {
        // to check if this product was selected before as a wishlist product or no
        if((gift.product_fav) == 0){
            //Add to wishlist
            let myURL = "http://192.168.64.2/dashboard/MyWebServices/api/setObjectInWishList.php"
            
            let pro_id = gift.Pro_id
            let params : Parameters = ["Pro_id":pro_id, "Email":usersEmaile]
            Alamofire.request(myURL, method: .post, parameters: params).responseString{
                response in
                switch(response.result){
                    // if successed
                case .success:
                    print("success")
                    // to change the image for favoirte button 
                    self.giftFav.setImage(UIImage.init(named: "like-1")!.withRenderingMode(.alwaysOriginal), for: .normal)
                    break
                    //if fail
                case .failure:
                    print(response.description)
                    break
                }
            }
        }
    }
}
