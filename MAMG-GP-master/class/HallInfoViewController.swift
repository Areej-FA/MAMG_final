
import UIKit
//import AVFoundation

class HallInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var hall = HallBean()
    
    @IBOutlet weak var hallImage: UIImageView!
    @IBOutlet weak var hallDescription: UILabel!
    @IBOutlet weak var hallsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(isItArabic){
            self.title = hall.Name_AR
            hallDescription.text = hall.Description_AR
        }else{
            self.title = hall.Name_E
            hallDescription.text = hall.Description_E
        }
        if let imageData = Data(base64Encoded: (hall.Picture)) {
            hallImage.image = UIImage(data: imageData)
        }
    }
    // number of columns
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (hall.objects.count)
    }
    // to fill rows with data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        
        let featureImage = cell.viewWithTag(1) as! UIImageView
        let featureName = cell.viewWithTag(2) as! UILabel
        
        
        if(isItArabic){
            featureName.text = hall.objects[indexPath.row].Name_AR
        }else{
            featureName.text = hall.objects[indexPath.row].Name_E
        }
        if let imageData = Data(base64Encoded: (hall.objects[indexPath.row].Picture)) {
            featureImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    @IBAction func audioAction(_ sender: Any) {
        var audioURL = ""
        if(isItArabic){
            audioURL = (hall.Audio_Ar)
        }else{
            audioURL = (hall.Audio_E)
        }
        print(audioURL)

        
        if let url = URL(string: audioURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func videoAction(_ sender: Any) {
        var videoURL = ""
        if(isItArabic){
            videoURL = (hall.Video_AR)
        }else{
            videoURL = (hall.Video_E)
        }
        print(videoURL)
        if let url = URL(string: videoURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
