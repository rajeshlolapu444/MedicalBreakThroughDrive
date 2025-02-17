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

    @IBOutlet weak var notesStackView: UIStackView!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var instructionsBgView: UIView!
    @IBOutlet weak var attachmentsStackView: UIStackView!
    
    @IBOutlet weak var instructionsStackView: UIStackView!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var startDeliveryBtnStackView: UIStackView!
    
    @IBOutlet weak var attachmentsCV: UICollectionView!
    
    var orderData : Order?
    var orderType : OrdersType?
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
        self.startDeliveryBtnStackView.isHidden = orderType == .Past
        self.instructionsStackView.isHidden = orderType == .Past
        self.notesStackView.isHidden = orderType == .Active
        self.attachmentsStackView.isHidden = orderType == .Active
        setupCollectionView()
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startDeliveryBtnAct(_ sender: UIButton) {
        let vc = GoogleMapViewController()
        vc.isfromHome = false
        vc.orderData = self.orderData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Setup Collection View
    func setupCollectionView() {
        attachmentsCV.delegate = self
        attachmentsCV.dataSource = self
        attachmentsCV?.register(UINib(nibName: "ImageListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageListCollectionViewCell")
    }

    func loadData(data: Order) {
        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        self.addressLbl.text = "\(data.address?.addressLine1 ?? ""), \(data.address?.city ?? ""),\(data.address?.state ?? ""), \(data.address?.country ?? ""),\(data.address?.postalCode ?? "")"
        if let formattedDate = convertDateFormat(dateString: data.orderTracking?.date ?? "", from: "yyyy-MM-dd") {
            self.timeLbl.text = formattedDate
        }
        if data.customer?.phone == "" || data.customer?.phone == nil {
            self.mobileNumberLbl.text = "N/A"
        } else {
            let usFormate = formatPhoneNumberUSA(data.customer?.phone ?? "")
            self.mobileNumberLbl.text = usFormate

        }
        if data.deliveryInstructions == "" || data.deliveryInstructions == nil {
            //self.instructionLbl.text = "N/A"
        } else {
            self.instructionLbl.text = data.deliveryInstructions ?? "N/A"
        }
        if data.deliveryDetails?.notes == "" || data.deliveryDetails?.notes == nil {
            self.notesLbl.text = "No notes"
        } else {
            self.notesLbl.text = data.deliveryDetails?.notes ?? ""
        }
        productImgView.setImage(from: data.products?.first?.productImage ?? "")
        
    }
}
// MARK: - Collection View Methods
extension OrderDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderData?.deliveryImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCollectionViewCell", for: indexPath) as! ImageListCollectionViewCell
        let mediaData = self.orderData?.deliveryImages?[indexPath.row]
        cell.imgView.layer.cornerRadius = 10
        cell.imgView.contentMode = .scaleToFill
        cell.previewImg.tintColor = .lightGray
        cell.deleteImgBtn.isHidden = true
        cell.takePhotoBtn.isHidden = true
        cell.imgView.setImage(from: mediaData?.url ?? "")
        if mediaData?.type == "image" {
            cell.previewImg.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        } else {
            cell.previewImg.image = UIImage(systemName: "play.circle.fill")
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 5  // Show 7 items
        let spacing: CGFloat = 0      // Adjust spacing if needed
        let totalSpacingorderData = spacing * (itemsPerRow - 1)
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaData = self.orderData?.deliveryImages?[indexPath.row]
        guard let data = mediaData else { return }
        if data.url != "" {
            let mType = data.type == "image" ? MediaType.image : MediaType.video
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(identifier: "VideoPerviewViewController") as! VideoPerviewViewController
            vc.mediaData = MediaItem(type: mType,url:data.url, thumbnail: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
