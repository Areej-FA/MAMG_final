import UIKit
import Alamofire
import SwiftyJSON

class FavoriteToursViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favoritesTableView: UITableView!
    var favouriteList = [FavoriteTourBean]()
    var selectedTourID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to check if the user is login or not
        if(isUserAGust == true)
        {
            //to show alert to the guest
            let alertController = UIAlertController(title: nil, message: "Sorry You Must Login ", preferredStyle: .alert)
            
            let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed the destructive");
            }
            
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }else{
            getFavorites()
        }
       
        
    }
    
    func getFavorites() {
        let myURL = URLNET+"getUserFavoriteTour.php"
        favouriteList.removeAll()
        
        let params : Parameters = ["Email":usersEmaile]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){
                //if response was successed
            case .success:
                print(response.value!)
                /// parse json data
                let json = JSON.init(parseJSON: response.value!)
                
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    
                    let dic = JSON(array[i])
                    let object = FavoriteTourBean()
                    object.Tour_id = dic["Tour_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Name_Ar = dic["Name_Ar"].stringValue
                    self.favouriteList.append(object)
                }
                if (self.favouriteList.count) < 1{
                    let alertController = UIAlertController(title: nil, message: "There are No Tours Favorited", preferredStyle: .alert)
                    
                    let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                    }
                    
                    alertController.addAction(action3)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.favoritesTableView.reloadData()
                break
                // if fail
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
        return (favouriteList.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    // to fill the controles with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        let favName = cell.viewWithTag(2) as! UILabel
        
        if(isItArabic){
            favName.text = favouriteList[indexPath.row].Name_Ar
        }else{
            favName.text = favouriteList[indexPath.row].Name_E
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.favoritesTableView.cellForRow(at: indexPath)
        let tour = favouriteList[indexPath.row]
        selectedTourID = tour.Tour_id
        self.performSegue(withIdentifier: "FavoriteTour", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FavoriteTour"){
            let tourInfo = segue.destination as! TourInfoViewController
            tourInfo.tourID = self.selectedTourID
        }
    }
    
    // to edit the row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            deleteFromFavorite(index: indexPath)
        }
    }
    // to move the row
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //  to delete a tour from favoite
    func deleteFromFavorite(index: IndexPath) {
        let myURL = URLNET+"deleteFavourite.php"
        
        let tour_id = favouriteList[index.row].Tour_id
        let params : Parameters = ["Email":usersEmaile, "Tour_id":tour_id]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){
                // if successed
            case .success:
                print(response.value!)
                //remove tour from arraylist
                self.favouriteList.remove(at: index.row)
                //remove tour from table view
                self.favoritesTableView.deleteRows(at: [index], with: .fade)
                break
                
            case .failure:
                print(response.description)
                break
            }
        }
    }
}
