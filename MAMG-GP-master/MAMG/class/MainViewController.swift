//
//  MainViewController.swift
//  MAMG
//
//  Created by Areej on 12/24/18.
//  Copyright © 2018 Areej. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //To the event interface
    @IBAction func toEvent(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventE") as! EventViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the IMAX interface
    @IBAction func toMovies(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImaxE") as! ImaxViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the main tour menu interface
    @IBAction func toTours(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tourE") as! MainTourViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the object identification interface
    @IBAction func toObjectId(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "objectidE") as! ObjectIdViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the about us interface
    @IBAction func toAboutUs(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutE") as! AboutUsViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the settings interface
    @IBAction func toSettings(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setE") as! SettingsViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the ticket info price interface
    @IBAction func toTickets(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ticketE") as! GetTicketViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the giftshop interface
    @IBAction func toGiftshop(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftE") as! GiftshopeViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the volunteer fourm interface
    @IBAction func toVolunteerFourm(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "volunteerE") as! VolunteersViewController
        self.present(cv, animated: true, completion: nil)
    }
    
    //To the visitation times interface
    @IBAction func toVisitationTimes(_ sender: Any) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "visitE") as! VisitTimeViewController
        self.present(cv, animated: true, completion: nil)
    }
    
}

