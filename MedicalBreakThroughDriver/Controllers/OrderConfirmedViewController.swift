//
//  OrderConfirmedViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import UIKit

class OrderConfirmedViewController: UIViewController {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!

    @IBOutlet weak var instructionsBgView: UIView!
    
    var orderData : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
//        instructionsBgView.layer.cornerRadius = 5
        instructionsBgView.layer.borderWidth = 1
        instructionsBgView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
        if let data = orderData {
            loadData(data: data)
        }
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeliveryBtnAct(_ sender: UIButton) {
//        let vc = ProofOfDeliveryVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        let orderVC = MAIN.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(orderVC, animated: true)
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
        loadImage(from: data.products?.first?.productImage ?? "", into: productImgView)
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
