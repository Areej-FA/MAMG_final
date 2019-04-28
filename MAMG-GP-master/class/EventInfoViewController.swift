import UIKit

class EventInfoViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    var startDate, endDate, time, price, group: UILabel?
    
    var event = EventBean()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startDate = self.view.viewWithTag(1) as? UILabel
        endDate = self.view.viewWithTag(2) as? UILabel
        time = self.view.viewWithTag(3) as? UILabel
        price = self.view.viewWithTag(4) as? UILabel
        group = self.view.viewWithTag(5) as? UILabel
        
        // to casting img from string to image
        
        if let imageData = Data(base64Encoded: (event.Picture)) {
            // passing image to image view
            eventImage.image = UIImage(data: imageData)
        }
        
        //Check if the language selected is arabic to display the values in arabis else the english values are displyed
        if(isItArabic){
            self.title = event.Name_AR
            eventName.text = event.Name_AR
        }else{
            self.title = event.Name_E
            eventName.text = event.Name_E
        }
        
        //set values in interface
        startDate!.text = event.Start_date
        endDate!.text = event.End_date
        
        if((event.activities.count) > 0){
            time!.text = event.activities[0].Time
            price!.text = event.activities[0].Ticket_Price
            group!.text = event.activities[0].Age_Group
        }
    }
}
