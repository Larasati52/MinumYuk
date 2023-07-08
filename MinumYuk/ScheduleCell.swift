
//
//  ScheduleCell.swift
//  MinumYuk
//
//  Created by Larasati on 24/06/23.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
