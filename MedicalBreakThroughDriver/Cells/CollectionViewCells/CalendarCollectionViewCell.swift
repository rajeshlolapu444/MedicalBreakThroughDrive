//
//  CalendarCollectionViewCell.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(day: Int, isSelected: Bool, isToday: Bool, weekday: String) {
        dateLbl.text = "\(day)"
        dayLabel.text = weekday
        
        if isSelected {
            dateLbl.backgroundColor = .blue
            dateLbl.textColor = .white
            dateLbl.layer.cornerRadius = dateLbl.frame.height / 2
            dateLbl.layer.masksToBounds = true

        } else if isToday {
            dateLbl.backgroundColor = .red
            dateLbl.textColor = .white
            dateLbl.layer.cornerRadius = dateLbl.frame.height / 2
            dateLbl.layer.masksToBounds = true

        } else {
            dateLbl.backgroundColor = .white
            dateLbl.textColor = .black
        }
    }
}
