import UIKit
import Alamofire
import SwiftyJSON

class ToursHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTableView: UITableView!
    var historyList = [TourHistoryBean]()
    var selectedTour: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(isUserAGust == true)
        {
            let alertController = UIAlertController(title: nil, message: "Sorry this is for registred users", preferredStyle: .alert)
            
            let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed the destructive");
            }
            
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }else{
        
            getToursHistory()
        }
        
    }
    
    func getToursHistory() {
        let myURL = URLNET+"getUserTourHistory.php"
        historyList.removeAll()
        
        let params : Parameters = ["Email":usersEmaile]
        Alamofire.request(myURL, method: .post, parameters: params).responseString{
            response in
            switch(response.result){
                
            case .success:
                print(response.value!)
                let json = JSON.init(parseJSON: response.value!)
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    let object = TourHistoryBean()
                    object.Tour_id = dic["Tour_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Name_Ar = dic["Name_Ar"].stringValue
                    object.date = dic["date"].stringValue
                    self.historyList.append(object)
                }
                if (self.historyList.count < 1){
                    let alertController = UIAlertController(title: nil, message: "This is No Tour History for this user", preferredStyle: .alert)
                    
                    let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                    }
                    
                    alertController.addAction(action3)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.historyTableView.reloadData()
                break
                
            case .failure:
                print(response.description)
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (historyList.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        let historyName = cell.viewWithTag(2) as! UILabel
        let historyDate = cell.viewWithTag(3) as! UILabel
        
        if(isItArabic){
            historyName.text = historyList[indexPath.row].Name_Ar
        }else{
            historyName.text = historyList[indexPath.row].Name_E
        }
        
        historyDate.text = historyList[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.historyTableView.cellForRow(at: indexPath)
        let tour = historyList[indexPath.row]
        selectedTour = tour.Tour_id
        self.performSegue(withIdentifier: "HistoryTour", sender: self)
        //ScitechTour
        //HistoryTour
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "HistoryTour"){
            let tourInfo = segue.destination as! TourInfoViewController
            tourInfo.tourID = self.selectedTour
        }
    }

}
