//
//  MyTableViewCell.swift
//  dustLjm
//
//  Created by 이정민 on 2021/06/11.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var pm10Value: UILabel!
    @IBOutlet weak var khaiGrade: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
