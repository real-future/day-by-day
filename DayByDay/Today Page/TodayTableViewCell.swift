//
//  TableViewCell.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellBoxView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var todoTitleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
