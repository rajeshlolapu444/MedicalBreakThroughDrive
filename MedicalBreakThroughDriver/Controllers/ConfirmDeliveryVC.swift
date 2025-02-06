//
//  ConfirmDeliveryVC.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit

class ConfirmDeliveryVC: UIViewController {
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
  //  @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
   // @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var selectLbl: UILabel!
    
    @IBOutlet weak var deliveredSelectionBgView: UIView!
    @IBOutlet weak var cancelledSelectionBgView: UIView!
    @IBOutlet weak var statusSelectionView: UIView!
    var orderData : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = orderData {
            loadData(data: data)
            self.deliveredSelectionBgView.isHidden = true
            self.cancelledSelectionBgView.isHidden = true
            self.statusSelectionView.layer.borderColor = UIColor.black.cgColor
            self.statusSelectionView.layer.borderWidth = 1
        }
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtnAct(_ sender: UIButton) {
        self.navigateToSummary()
    }
    func navigateToSummary() {
        let vc = MAIN.instantiateViewController(withIdentifier: "SummaryPageViewController") as! SummaryPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToHome() {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func statusSelectionBtnAct(_ sender: UIButton) {
        self.selectLbl.text = "Select Status"
        self.selectLbl.textColor = .darkGray
        self.deliveredSelectionBgView.isHidden = !self.deliveredSelectionBgView.isHidden
        self.cancelledSelectionBgView.isHidden = !self.cancelledSelectionBgView.isHidden
    }
    @IBAction func deliveredSelectionBtnAct(_ sender: UIButton) {
        self.selectLbl.text = "Delivered"
        self.selectLbl.textColor = .systemGreen
        self.deliveredSelectionBgView.isHidden = true
        self.cancelledSelectionBgView.isHidden = true
    }
    @IBAction func cancelledSelectionBtnAct(_ sender: UIButton) {
        self.selectLbl.text = "Cancelled"
        self.selectLbl.textColor = .systemRed
        self.deliveredSelectionBgView.isHidden = true
        self.cancelledSelectionBgView.isHidden = true
    }
    func loadData(data: Order) {
        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        if let formattedDate = convertDateFormat(dateString: data.createdAt ?? "", from: "yyyy-MM-dd HH:mm:ss") {
            self.timeLbl.text = formattedDate
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
