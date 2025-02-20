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
    @IBOutlet weak var contactBgView: UIView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var notesBgView: UIView!
    @IBOutlet weak var milesBgView: UIView!
    @IBOutlet weak var milesLbl: UILabel!
    @IBOutlet weak var callNumberBtn: UIButton!
    var notesBtn: (() -> Void)?
    var numberBtn: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func callNumberBtnAct(_ sender: UIButton) {
        self.numberBtn?()
    }
    @IBAction func notesBtnAct(_ sender: UIButton) {
        self.notesBtn?()
    }
    func loadData(data: Order,ordersType:OrdersType) {

        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        self.addressLbl.text = "\(data.address?.addressLine1 ?? ""), \(data.address?.city ?? ""),\(data.address?.state ?? ""), \(data.address?.country ?? ""),\(data.address?.postalCode ?? "")"
        if let formattedDate = convertDateFormat(dateString: data.orderTracking?.date ?? "", from: "yyyy-MM-dd") {
            self.timeLbl.text = formattedDate
        }
        productImgView.setImage(from: data.products?.first?.productImage ?? "")
     //   self.confirmedBtn.setTitle(data.status ?? "", for: .normal)
        if data.customer?.phone == nil || data.customer?.phone == "" {
            self.contactBgView.isHidden = true
        } else {
            self.contactBgView.isHidden = false
            let usFormate = formatPhoneNumberUSA(data.customer?.phone ?? "")
            self.contactLbl.text = usFormate
        }
        if ordersType == .Past {
            if data.deliveryDetails?.notes == nil || data.deliveryDetails?.notes == "" {
                self.notesBgView.isHidden = true
            } else {
                self.notesBgView.isHidden = false
            }
        }
        
//        let storeLatitude: Double = PersistenceStorage.sharedInstance.storeAddressLatitude ?? 40.730610
//        let storeLongitude: Double = PersistenceStorage.sharedInstance.storeAddressLongitude ?? -73.935242
//        let latitude: Double = data.address?.latitude ?? 0
//        let longitude: Double = data.address?.longitude ?? 0
//        let miles = HomeViewModel.shared.calculateDistance(lat1: storeLatitude, lon1: storeLongitude, lat2: latitude, lon2: longitude)
//        self.milesLbl.text = String(format: "%.2f", miles) + " miles"
        self.milesLbl.text =  (data.address?.distance_in_miles ?? "") + " miles"
        self.milesBgView.isHidden = !(ordersType == .Active)


    }
}
// MARK: - NibReusable
extension MyOrdersListTableViewCell: NibReusable { }


