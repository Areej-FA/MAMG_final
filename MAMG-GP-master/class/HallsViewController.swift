import UIKit
import Alamofire
import SwiftyJSON

class HallsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var hallsCollectionView: UICollectionView!
    var hallsList = [HallBean]()
    var hall = HallBean()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hallsCollectionView!.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        print("Getting halls")
        getHalls()
    }
    
    func getHalls() {
        let myURL = URLNET + "getHalls.php"
        hallsList.removeAll()
        print("sending request")
        Alamofire.request(myURL, method: .post).responseJSON{
            response in
            switch(response.result){
                // case successed
            case .success:
                let json = JSON(response.data!)
                print(json)
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    let object = HallBean()

                    object.Hall_id = dic["Hall_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Picture = dic["Picture"].stringValue
                
                        object.Audio_E = dic["Audio_E"].stringValue
                    
                    
                        object.Video_E = dic["Video_E"].stringValue
                    
                    object.Description_E = dic["Description_E"].stringValue
                    object.Name_AR = dic["Name_AR"].string!
                 
                        object.Audio_Ar =  dic["Audio_Ar"].stringValue
                    
                  
                        object.Video_AR = dic["Video_AR"].stringValue
                    
                    object.Description_AR = dic["Description_AR"].stringValue 
                    
                    var featuresList = [HallObjectBean]()
                    let featuresArray = dic["objects"].arrayValue
                    for j in 0..<featuresArray.count {
                        let featuresDic = JSON(featuresArray[j])
                        let obj = HallObjectBean()
                        
                        obj.Object_id = featuresDic["Object_id"].stringValue
                        obj.Name_E = featuresDic["Name_E"].stringValue
                        obj.Picture = featuresDic["Picture"].stringValue
                        obj.Description_E = featuresDic["Description_E"].stringValue
                        obj.Resource_E = featuresDic["Resource_E"].stringValue
                        obj.Rate_Count = featuresDic["Rate_Count"].stringValue
                        obj.Rate = featuresDic["Rate"].stringValue
                        obj.Hall_id = featuresDic["Hall_id"].stringValue
                        obj.Name_AR = featuresDic["Name_AR"].stringValue
                        obj.Description_AR = featuresDic["Description_AR"].stringValue
                        obj.Resource_AR = featuresDic["Resource_AR"].stringValue
                        
                        featuresList.append(obj)
                    }
                    
                    object.objects = featuresList
                    // to add object to hallslist
                    self.hallsList.append(object)
                    //check if list is empty
                    if (self.hallsList.isEmpty)
                    {
                        let alertController = UIAlertController(title: nil, message: "There is No Halls", preferredStyle: .alert)
                        
                        let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                            print("You've pressed the destructive");
                        }
                        
                        alertController.addAction(action3)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                self.hallsCollectionView.reloadData()
                break
                
            case .failure:
                break
            }
        }
    }
    
    // //number of columns
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (hallsList.count)
    }
    //fill controles with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        
        let hallImage = cell.viewWithTag(1) as! UIImageView
        let hallName = cell.viewWithTag(2) as! UILabel
        
        if(isItArabic){
            hallName.text = hallsList[indexPath.row].Name_AR
        }else{
            hallName.text = hallsList[indexPath.row].Name_E
        }
        
        if let imageData = Data(base64Encoded: hallsList[indexPath.row].Picture) {
            hallImage.image = UIImage(data: imageData)
        }
        return cell
    }
    // to know wich row was selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hall = hallsList[indexPath.row]
        self.performSegue(withIdentifier: "hallInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "hallInfo"){
            let hallInfoVC = segue.destination as! HallInfoViewController
            hallInfoVC.hall = self.hall
        }
    }
}
