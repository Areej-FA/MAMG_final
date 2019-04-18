//
//  PlanATour2TableCellViewController.swift
//  MAMG
//
//  Created by Adhwaa Ahmed on 18/04/2019.
//  Copyright © 2019 Areej. All rights reserved.
//

import UIKit

class PlanATour2TableCellViewController: UITableViewCell {

    @IBOutlet weak var ObjImg: UIImageView!
    
    @IBOutlet weak var ObjName: UILabel!
    
    @IBOutlet weak var SelHall: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
