import UIKit
import Alamofire
import SwiftyJSON

class ImaxViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var moviesList =  [MovieBean]()
    var movie = MovieBean()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesCollectionView!.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        getMovies()
    }
    
    func getMovies() {
        let myURL = "http://" + networkIP + "/magazin/MyWebServices/api/getMovies.php"
        moviesList.removeAll()
        
        Alamofire.request(myURL, method: .get, parameters: nil).responseJSON{
            response in
            switch(response.result){
                
            case .success:
                let json = JSON(response.data!)
                let array = json["product"].arrayValue
                for i in 0..<array.count {
                    let dic = JSON(array[i])
                    let object = MovieBean()
                    object.Moive_id = dic["Movie_id"].stringValue
                    object.Name_E = dic["Name_E"].stringValue
                    object.Description_E = dic["Description_E"].stringValue
                    object.Picture = dic["Picture"].stringValue
                    object.Trailer = dic["Trailer"].stringValue
                    object.Name_AR = dic["Name_AR"].stringValue
                    object.Description_Ar = dic["Description_Ar"].stringValue 
                    
                    var timesList = [TimeBean]()
                    let timesArray = dic["times"].arrayValue
                    for j in 0..<timesArray.count {
                        let timesDic = JSON(timesArray[j])
                        let obj = TimeBean()
                        obj.Day = timesDic["Day"].stringValue
                        obj.Time = timesDic["Time"].stringValue
                        timesList.append(obj)
                    }
                    object.times = timesList
                    self.moviesList.append(object)
                }
                if self.moviesList.count == 0{
                    let alertController = UIAlertController(title: nil, message: "This is No Movies", preferredStyle: .alert)
                  
                    let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                        print("You've pressed the destructive");
                    }
                 
                    alertController.addAction(action3)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.moviesCollectionView.reloadData()
                break
                
            case .failure:
                break
            }
        }
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        
        let movieImage = cell.viewWithTag(1) as! UIImageView
        let movieName = cell.viewWithTag(2) as! UILabel
        
        if(isItArabic){
            movieName.text = moviesList[indexPath.row].Name_AR
        }else{
            movieName.text = moviesList[indexPath.row].Name_E
        }
        
        if let imageData = Data(base64Encoded: moviesList[indexPath.row].Picture) {
            movieImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movie = moviesList[indexPath.row]
        self.performSegue(withIdentifier: "movieInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "movieInfo"){
            let movieInfoVC = segue.destination as! MovieInfoViewController
            movieInfoVC.movie = self.movie
        }
    }
}
