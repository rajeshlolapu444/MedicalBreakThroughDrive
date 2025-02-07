//
//  ConfirmDeliveryVC.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit
import AVFoundation
import MobileCoreServices

struct MediaItem {
    let type: MediaType
    let url: URL
    var thumbnail: UIImage? // Only for videos
}


class ConfirmDeliveryVC: UIViewController {
    @IBOutlet weak var notesBgView: UIView!
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
    
    @IBOutlet weak var uploadImageBgView: UIView!
    @IBOutlet weak var mediaCountLbl: UILabel!
    @IBOutlet weak var imageListCV: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    
    var orderData : Order?
    var mediaItems: [MediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notesBgView.layer.borderWidth = 1
        self.notesBgView.layer.borderColor = UIColor.lightGray.cgColor
        if let data = orderData {
            loadData(data: data)
            self.deliveredSelectionBgView.isHidden = true
            self.cancelledSelectionBgView.isHidden = true
            self.statusSelectionView.layer.borderColor = UIColor.black.cgColor
            self.statusSelectionView.layer.borderWidth = 1
        }
        setupCollectionView()
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
    
    @IBAction func uploadImageAndVideoBtnAct(_ sender: UIButton) {
        self.openCamera()
    }
    // MARK: - Setup Collection View
    func setupCollectionView() {
        imageListCV.delegate = self
        imageListCV.dataSource = self
        imageListCV?.register(UINib(nibName: "ImageListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageListCollectionViewCell")
    }
}
// MARK: - UIImage PickerView Methods
extension ConfirmDeliveryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.delegate = self
        picker.videoQuality = .typeHigh
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    // Delegate method when media is picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.image", let image = info[.originalImage] as? UIImage {
                saveImageToDocuments(image: image)
            } else if mediaType == "public.movie", let videoURL = info[.mediaURL] as? URL {
                saveVideoToDocuments(videoURL: videoURL)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func saveImageToDocuments(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            let mediaItem = MediaItem(type: .image, url: fileURL, thumbnail: nil)
            mediaItems.append(mediaItem)
            debugPrint(mediaItems,"mediaItemsss")
            self.mediaCountLbl.text = "\(mediaItems.count)/10"
            imageListCV.reloadData()
            if mediaItems.count > 0 {
                self.uploadImageBgView.isHidden = true
                self.imageListCV.isHidden = false
            } else {
                self.uploadImageBgView.isHidden = false
                self.imageListCV.isHidden = true
            }
        } catch {
            print("Failed to save image: \(error)")
        }
    }
    func saveVideoToDocuments(videoURL: URL) {
        let fileName = UUID().uuidString + ".mov"
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.copyItem(at: videoURL, to: destinationURL)
            let thumbnail = generateThumbnail(for: destinationURL)
            let mediaItem = MediaItem(type: .video, url: destinationURL, thumbnail: thumbnail)
            mediaItems.append(mediaItem)
            debugPrint(mediaItems,"mediaItemsss")
            self.mediaCountLbl.text = "\(mediaItems.count)/10"
            imageListCV.reloadData()
            if mediaItems.count > 0 {
                self.uploadImageBgView.isHidden = true
                self.imageListCV.isHidden = false
            } else {
                self.uploadImageBgView.isHidden = false
                self.imageListCV.isHidden = true
            }
        } catch {
            print("Failed to save video: \(error)")
        }
    }
    func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
    @objc func deleteImage(_ sender: UIButton) {
        mediaItems.remove(at:sender.tag)
        self.mediaCountLbl.text = "\(mediaItems.count)/10"
        imageListCV.reloadData()
        if mediaItems.count > 0 {
            self.uploadImageBgView.isHidden = true
            self.imageListCV.isHidden = false
        } else {
            self.uploadImageBgView.isHidden = false
            self.imageListCV.isHidden = true
        }
    }
}

// MARK: - Collection View Methods
extension ConfirmDeliveryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mediaItems.count == 0 {
            return 1
        } else if mediaItems.count == 10 {
            return mediaItems.count
        }
        return mediaItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCollectionViewCell", for: indexPath) as! ImageListCollectionViewCell
//        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
//        cell.bgView.layer.borderWidth = 1
        cell.imgView.layer.cornerRadius = 10
        cell.imgView.contentMode = .scaleToFill
        cell.previewImg.tintColor = .lightGray
        if mediaItems.count == 0 {
            cell.takePhotoBtn.isHidden = false
            cell.deleteImgBtn.isHidden = true
            cell.imgView.image = nil
        } else {
            if indexPath.row == mediaItems.count {
                cell.takePhotoBtn.isHidden = false
                cell.deleteImgBtn.isHidden = true
                cell.imgView.image = nil
            } else {
                let mediaData = self.mediaItems[indexPath.row]
                cell.takePhotoBtn.isHidden = true
                cell.deleteImgBtn.isHidden = false
                //  cell.imgView.image = imageListArray[indexPath.row]
                if mediaData.type == MediaType.image {
                    cell.imgView.image = UIImage(contentsOfFile: mediaData.url.path)
                } else {
                    cell.imgView.image = mediaData.thumbnail
                }
                if mediaData.type == .image {
                    cell.previewImg.image = UIImage(systemName: "arrow.up.left.and.arrow.down.right")
                } else {
                    cell.previewImg.image = UIImage(systemName: "play.circle.fill")
                }
            }
        }
        cell.previewImg.isHidden = !cell.takePhotoBtn.isHidden
        cell.takePhotoBtn.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        cell.deleteImgBtn.tag = indexPath.row
        cell.deleteImgBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 5  // Show 7 items
        let spacing: CGFloat = 0      // Adjust spacing if needed
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        if mediaItems.count >= 5 {
            let height: CGFloat = itemWidth * 2
            CollectionViewHeight.constant = height + 10
        } else {
            CollectionViewHeight.constant = itemWidth + 10
        }
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = mediaItems[indexPath.row]
        if data.url.absoluteString != "" {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(identifier: "VideoPerviewViewController") as! VideoPerviewViewController
            vc.mediaData = data
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}


//extension ConfirmDeliveryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func openMediaPicker() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//        picker.videoQuality = .typeHigh
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
//    }
//    // Handle Picked Media
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[.originalImage] as? UIImage {
//            // Save Image and Get URL
//            if let imageUrl = saveImageToDocumentsDirectory(image: image) {
//                let media = MediaItem(type: .image, url: imageUrl, thumbnail: nil)
//                mediaItems.append(media)
//            }
//        } else if let videoUrl = info[.mediaURL] as? URL {
//            // Generate Video Thumbnail
//            let thumbnail = generateThumbnail(for: videoUrl)
//            let media = MediaItem(type: .video, url: videoUrl, thumbnail: thumbnail)
//            mediaItems.append(media)
//        }
//
//        dismiss(animated: true)
//    }
//    func saveImageToDocumentsDirectory(image: UIImage) -> URL? {
//        let fileName = UUID().uuidString + ".jpg"
//        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//
//        if let data = image.jpegData(compressionQuality: 0.8) {
//            try? data.write(to: fileURL)
//            return fileURL
//        }
//        return nil
//    }
//    func generateThumbnail(for url: URL) -> UIImage? {
//        let asset = AVAsset(url: url)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        imageGenerator.appliesPreferredTrackTransform = true
//
//        do {
//            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
//            return UIImage(cgImage: cgImage)
//        } catch {
//            print("Error generating thumbnail: \(error)")
//            return nil
//        }
//    }
//}
