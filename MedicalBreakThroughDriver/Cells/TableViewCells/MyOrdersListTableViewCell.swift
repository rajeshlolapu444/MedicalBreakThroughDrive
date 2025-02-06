//
//  MyOrdersListTableViewCell.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import UIKit

class MyOrdersListTableViewCell: UITableViewCell {
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var confirmedBtn: UIButton!
    var confirmedBtnNavi: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func confirmedBtnAct(_ sender: UIButton) {
        confirmedBtnNavi?()
    }
    func loadData(data: Order) {
        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        self.addressLbl.text = "\(data.address?.addressLine1 ?? ""), \(data.address?.city ?? ""),\(data.address?.state ?? ""), \(data.address?.country ?? ""),\(data.address?.postalCode ?? "")"
        if let formattedDate = convertDateFormat(dateString: data.createdAt ?? "", from: "yyyy-MM-dd HH:mm:ss") {
            self.timeLbl.text = formattedDate
        }
        loadImage(from: data.products?.first?.productImage ?? "", into: productImgView)
     //   self.confirmedBtn.setTitle(data.status ?? "", for: .normal)
        if data.customer?.phone == nil || data.customer?.phone == "" {
            self.contactLbl.text = "No Cantact"
        } else {
            self.contactLbl.text = data.customer?.phone
        }
    }
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }

}
// MARK: - NibReusable
extension MyOrdersListTableViewCell: NibReusable { }


