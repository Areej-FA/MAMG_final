import UIKit
import YoutubePlayer_in_WKWebView

class MovieInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieTimesTableView: UITableView!
    @IBOutlet weak var trailerView: WKYTPlayerView!
    
    var movie = MovieBean()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(isItArabic){
            self.title = movie.Name_AR
            movieName.text = movie.Name_AR
            movieDescription.text = movie.Description_Ar
        }else{
            self.title = movie.Name_E
            movieName.text = movie.Name_E
            movieDescription.text = movie.Description_E
        }
        backView.layer.cornerRadius = 15
        
        if let imageData = Data(base64Encoded: (movie.Picture)) {
            movieImage.image = UIImage(data: imageData)
        }
        // to cut the video id from link
        let videoLink = movie.Trailer
        let videoId = videoLink.substring(from: "https://youtu.be/".endIndex)
     // to load video
        trailerView.load(withVideoId: videoId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // to check if there is data or not then show alert if there is no data
        if (movie.times.count) == 0{
            let alertController = UIAlertController(title: nil, message: "This is No Movie Items", preferredStyle: .alert)
            
            let action3 = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction) in
                print("You've pressed the destructive");
            }
            
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // to represent data in one columns
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // to represent data  in same number or rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movie.times.count)
    }
    // to passing data to controller daylabel and time label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dayLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        
        dayLabel.text = movie.times[indexPath.row].Day
        timeLabel.text = movie.times[indexPath.row].Time
        
        return cell
    }
}
