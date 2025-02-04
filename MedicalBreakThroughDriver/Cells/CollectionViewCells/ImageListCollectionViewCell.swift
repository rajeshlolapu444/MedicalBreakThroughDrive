//
//  ImageListCollectionViewCell.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 31/01/25.
//

import UIKit

class ImageListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
