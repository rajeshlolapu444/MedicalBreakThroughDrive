//
//  OrderDetailViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var instructionsBgView: UIView!
    
    @IBOutlet weak var instructionLbl: UILabel!
    var orderData : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsBgView.layer.cornerRadius = 5
        instructionsBgView.layer.borderWidth = 1
        instructionsBgView.layer.borderColor = UIColor.clear.cgColor
        productImgView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        if let data = orderData {
            loadData(data: data)
        }
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeliveryBtnAct(_ sender: UIButton) {
//        HomeViewModel.shared.putOrdersStatusAPI(orderId: orderData?.orderID ?? 0, status: DeliveryStatus.accepted.rawValue) { status, msg in
//            if status {
//                self.showToast(message: msg ?? "")
//            } else {
//                self.showToast(message: msg ?? "")
//            }
//        }
//        let vc = MAIN.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        vc.orderData = self.orderData
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = GoogleMapViewController()
        vc.isfromHome = false
        vc.orderData = self.orderData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func loadData(data: Order) {
        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        self.addressLbl.text = "\(data.address?.addressLine1 ?? ""), \(data.address?.city ?? ""),\(data.address?.state ?? ""), \(data.address?.country ?? ""),\(data.address?.postalCode ?? "")"
        if let formattedDate = convertDateFormat(dateString: data.createdAt ?? "", from: "yyyy-MM-dd HH:mm:ss") {
            self.timeLbl.text = formattedDate
        }
        if data.customer?.phone == "" || data.customer?.phone == nil {
            self.mobileNumberLbl.text = "N/A"
        } else {
            self.mobileNumberLbl.text = data.customer?.phone ?? "N/A"
        }
        if data.deliveryInstructions == "" || data.deliveryInstructions == nil {
            //self.instructionLbl.text = "N/A"
        } else {
            self.instructionLbl.text = data.deliveryInstructions ?? "N/A"
        }
        productImgView.setImage(from: data.products?.first?.productImage ?? "")
        
    }
}
