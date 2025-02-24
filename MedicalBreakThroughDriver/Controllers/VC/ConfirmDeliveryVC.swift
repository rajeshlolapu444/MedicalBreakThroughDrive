//
//  ConfirmDeliveryVC.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit
import AVFoundation
import MobileCoreServices
import SDWebImage
import AWSS3
import AWSCore
import PhotosUI
import AVKit
struct MediaItem {
    var type: MediaType
    var url: String?
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
    @IBOutlet weak var statusSelectionSubView: UIView!
    
    @IBOutlet weak var uploadImageBgView: UIView!
    @IBOutlet weak var mediaCountLbl: UILabel!
    @IBOutlet weak var imageListCV: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var orderData : Order?
    var mediaItems: [MediaItem] = []
    var deliveryStatus : DeliveryStatus = .delivered
    let placeholderText = "Add your Notes..."

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notesBgView.layer.borderWidth = 1
        self.notesBgView.layer.borderColor = UIColor.lightGray.cgColor
        self.statusSelectionSubView.layer.cornerRadius = 5
        self.statusSelectionSubView.layer.borderWidth = 2
        self.statusSelectionSubView.layer.borderColor = UIColor.lightGray.cgColor
        self.setupTextView()
        if let data = orderData {
            loadData(data: data)
            self.deliveredSelectionBgView.isHidden = true
            self.cancelledSelectionBgView.isHidden = true
           // self.statusSelectionView.layer.borderColor = UIColor.black.cgColor
            //self.statusSelectionView.layer.borderWidth = 1
        }
        setupCollectionView()
        
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtnAct(_ sender: UIButton) {
        self.navigateToSummary()
    }
    // MARK: - Setup Collection View
    func setupCollectionView() {
        imageListCV.delegate = self
        imageListCV.dataSource = self
        imageListCV?.register(UINib(nibName: "ImageListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageListCollectionViewCell")
    }
    func setupTextView() {
        notesTextView.delegate = self
        let notes = orderData?.deliveryDetails?.notes ?? ""
        if notes == "" {
            notesTextView.text = placeholderText
            notesTextView.textColor = UIColor.lightGray
        } else {
            notesTextView.textColor = UIColor.black
            self.notesTextView.text = orderData?.deliveryDetails?.notes ?? ""
        }
    }

    func navigateToSummary() {
        let vc = MAIN.instantiateViewController(withIdentifier: "SummaryPageViewController") as! SummaryPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToThankYou() {
        let vc = ThankYouViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func navigateToHome() {
        let homeViewController = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    @IBAction func statusSelectionBtnAct(_ sender: UIButton) {
        self.selectLbl.text = "Delivered"
        self.selectLbl.textColor = .systemGreen
        self.deliveredSelectionBgView.isHidden = !self.deliveredSelectionBgView.isHidden
        self.cancelledSelectionBgView.isHidden = !self.cancelledSelectionBgView.isHidden
        self.deliveryStatus = .delivered
        self.mediaCountLbl.isHidden = false
        if mediaItems.count > 0 {
            self.uploadImageBgView.isHidden = true
            self.imageListCV.isHidden = false
        } else {
            self.uploadImageBgView.isHidden = false
            self.imageListCV.isHidden = true
        }
        
    }
    @IBAction func deliveredSelectionBtnAct(_ sender: UIButton) {
        self.selectLbl.text = "Delivered"
        self.selectLbl.textColor = .systemGreen
        self.deliveredSelectionBgView.isHidden = true
        self.cancelledSelectionBgView.isHidden = true
        self.deliveryStatus = .delivered
        self.mediaCountLbl.isHidden = false
        if mediaItems.count > 0 {
            self.uploadImageBgView.isHidden = true
            self.imageListCV.isHidden = false
        } else {
            self.uploadImageBgView.isHidden = false
            self.imageListCV.isHidden = true
        }
    }
    @IBAction func cancelledSelectionBtnAct(_ sender: UIButton) {
        
        self.selectLbl.text = "Installed"
        self.selectLbl.textColor = .systemGreen
        self.deliveredSelectionBgView.isHidden = true
        self.cancelledSelectionBgView.isHidden = true
        self.deliveryStatus = .delivered
        self.mediaCountLbl.isHidden = false
        if mediaItems.count > 0 {
            self.uploadImageBgView.isHidden = true
            self.imageListCV.isHidden = false
        } else {
            self.uploadImageBgView.isHidden = false
            self.imageListCV.isHidden = true
        }
//        
//        self.selectLbl.text = "Installed"
//        self.selectLbl.textColor = .systemRed
//        self.deliveredSelectionBgView.isHidden = true
//        self.cancelledSelectionBgView.isHidden = true
//        self.deliveryStatus = .installed
//        self.mediaCountLbl.isHidden = true
//        self.uploadImageBgView.isHidden = true
//        self.imageListCV.isHidden = true
    }
    func loadData(data: Order) {
        self.orderIdLbl.text = "#\(data.orderID ?? 0)"
        self.productNameLbl.text = data.products?.first?.productName
        self.customerNameLbl.text = data.customer?.name
        if let formattedDate = convertDateFormat(dateString: data.orderTracking?.date ?? "", from: "yyyy-MM-dd") {
            self.timeLbl.text = formattedDate
        }
        self.addressLbl.text = "\(data.address?.addressLine1 ?? ""), \(data.address?.city ?? ""),\(data.address?.state ?? ""), \(data.address?.country ?? ""),\(data.address?.postalCode ?? "")"
        productImgView.setImage(from: data.products?.first?.productImage ?? "")
    }
    
    @IBAction func uploadImageAndVideoBtnAct(_ sender: UIButton) {
        self.mediaBtnTapped()
    }
    @IBAction func submitBtnAct(_ sender: UIButton) {
        switch deliveryStatus {
        case .delivered:
            self.submitApiCall(status: DeliveryStatus.delivered.rawValue)
        case .installed:
            self.submitApiCall(status: DeliveryStatus.installed.rawValue)
        case .rejected:
            if notesTextView.text == "" {
                self.showToast(message: "Notes required")
                return
            }
//            let rejectParams = CancelledDeliveryRequestModel(order_id: orderData?.id ?? 0, status: DeliveryStatus.installed.rawValue, reason:notesTextView.text ?? "")
//            debugPrint(rejectParams,"installedParams")
//            LoaderView.shared.showLoader(in: self.view)
//            ConfirmViewModel.shared.putOrdersCancellAPI(parms: rejectParams) { status, msg in
//                if status {
//                    self.showToast(message: msg ?? "")
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        LoaderView.shared.hideLoader()
//                        self.navigateToSummary()
//                    }
//                } else {
//                    self.showToast(message: msg ?? "")
//                    LoaderView.shared.hideLoader()
//                }
//            }
        case .none:
            self.showToast(message: "Plese select status")
        }
    }
    
// MARK: - Submit Methods
    func submitApiCall(status:String) {
        var attachments: [AttechmentRequestModel] = []
        var att = AttechmentRequestModel()
        for i in 0..<self.mediaItems.count {
            if self.mediaItems[i].type == .image {
                att.attachment_type = "image"
            } else {
                att.attachment_type = "video"
            }
            att.url = self.mediaItems[i].url
            attachments.append(att)
        }
        if notesTextView.text == "" || notesTextView.text == placeholderText {
            self.showToast(message: "Notes required")
            return
        }
        if attachments.count == 0 {
            self.showToast(message: "Please upload atleast one attachment")
        } else {
            let params = ConfirmDeliveryRequestModel(order_id: orderData?.id ?? 0, status: status, attachments: attachments, reason: self.notesTextView.text ?? "")
            debugPrint(params,"params")
            LoaderView.shared.showLoader(in: self.view)
            ConfirmViewModel.shared.putOrdersConfirmAPI(parms: params) { status, msg in
                if status {
                    self.showToast(message: msg ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        LoaderView.shared.hideLoader()
                        self.navigateToThankYou()
                    }
                } else {
                    self.showToast(message: msg ?? "")
                    LoaderView.shared.hideLoader()
                }
            }
        }
    }
    @objc func mediaBtnTapped(){
        let alertView = UIAlertController(title: "Please choose one", message: nil, preferredStyle: .actionSheet)
             let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
                 AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                     if response {
                         DispatchQueue.main.async {
                             self.openCamera()
                         }
                     } else {
                         DispatchQueue.main.async {
                             let alertView = UIAlertController(title: "Are you sure?", message: "We appreciate your concern about denying this permission, but it will give you a seamless experience.", preferredStyle: .alert)
                             let cancelAction: UIAlertAction = UIAlertAction(title: "Allow Later", style: .cancel) { action -> Void in
                                 alertView.dismiss(animated: true, completion: nil)
                             }
                             let allowNowAction: UIAlertAction = UIAlertAction(title: "Allow Now", style: .default) { action -> Void in
                                 UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                             }
                             alertView.addAction(cancelAction)
                             alertView.addAction(allowNowAction)
                             AppUtils.presentOnRootViewController(alertView)

                         }
                     }
                 }
             }
             let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
                 self.openPhotoLibrary()
     
             }
             let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
             }
     
             alertView.addAction(cameraAction)
             alertView.addAction(photoLibraryAction)
             alertView.addAction(cancelAction)
        AppUtils.presentOnRootViewController(alertView)

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
                if mediaData.type == MediaType.image {
                    cell.imgView.setImage(from: mediaData.url ?? "")
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
        cell.takePhotoBtn.addTarget(self, action: #selector(mediaBtnTapped), for: .touchUpInside)
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
        if indexPath.row >= mediaItems.count { return }
        let data = mediaItems[indexPath.row]
        if data.url != "" {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(identifier: "VideoPerviewViewController") as! VideoPerviewViewController
            vc.mediaData = data
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
// MARK: - UITextViewDelegate
extension ConfirmDeliveryVC:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
}
// MARK: - UIImagePickerController Delegate
extension ConfirmDeliveryVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    // MARK: - Open Camera
        func openCamera() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.delegate = self
            picker.videoQuality = .typeHigh
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    // MARK: - Open Photo Library
        func openPhotoLibrary() {
            var config = PHPickerConfiguration()
            config.filter = .any(of: [.images, .videos])
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        }
    // MARK: - UIImagePickerController Delegate (For Camera)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageURL = saveImageToDocuments(image: image) {
                LoaderView.shared.showLoader(in: view)
                uploadMediaToS3(fileURL: imageURL) { result in
                    switch result {
                    case .success(let url):
                        print("Image uploaded to S3: \(url)")
                        debugPrint(url, "awsS3ImageUrl")
                        let mediaItem = MediaItem(type: .image, url: url, thumbnail: nil)
                        self.mediaItems.append(mediaItem)
                        self.mediaCountLbl.text = "\(self.mediaItems.count)/10"
                        self.imageListCV.reloadData()
                        LoaderView.shared.hideLoader()
                        if self.mediaItems.count > 0 {
                            self.uploadImageBgView.isHidden = true
                            self.imageListCV.isHidden = false
                        } else {
                            self.uploadImageBgView.isHidden = false
                            self.imageListCV.isHidden = true
                        }
                    case .failure(let error):
                        LoaderView.shared.hideLoader()
                        print("Upload failed: \(error.localizedDescription)")
                    }
                }
            }
        } else if let videoURL = info[.mediaURL] as? URL {
            LoaderView.shared.showLoader(in: view)
            var thumbnailImage: UIImage? = nil
            self.generateThumbnail(from: videoURL) { thumbnail in
                if let thumbnail = thumbnail {
                    DispatchQueue.main.async {
                        thumbnailImage = thumbnail // Set thumbnail to UIImageView
                    }
                }
            }
            convertMovToMp4(sourceURL: videoURL) { mp4URL in
                guard let mp4URL = mp4URL else {
                    LoaderView.shared.hideLoader()
                    print("MP4 conversion failed")
                    return
                }
                
                self.uploadMediaToS3(fileURL: mp4URL) { result in
                    switch result {
                    case .success(let url):
                        print("Video uploaded to S3: \(url)")
                        debugPrint(url, "awsS3ImageUrl")
                        let mediaItem = MediaItem(type: .video, url: url, thumbnail: thumbnailImage)
                        self.mediaItems.append(mediaItem)
                        self.mediaCountLbl.text = "\(self.mediaItems.count)/10"
                        self.imageListCV.reloadData()
                        LoaderView.shared.hideLoader()
                        if self.mediaItems.count > 0 {
                            self.uploadImageBgView.isHidden = true
                            self.imageListCV.isHidden = false
                        } else {
                            self.uploadImageBgView.isHidden = false
                            self.imageListCV.isHidden = true
                        }
                    case .failure(let error):
                        LoaderView.shared.hideLoader()
                        print("Upload failed: \(error.localizedDescription)")
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
    // MARK: - PHPickerViewController Delegate (For Library)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let item = results.first?.itemProvider else { return }
        
        if item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage, let imageURL = self.saveImageToDocuments(image: image) {
                    DispatchQueue.main.async {
                        LoaderView.shared.showLoader(in: self.view)
                    }
                    self.uploadMediaToS3(fileURL: imageURL) { result in
                        switch result {
                        case .success(let url):
                            print("Image uploaded to S3: \(url)")
                            debugPrint(url, "awsS3ImageUrl")
                            let mediaItem = MediaItem(type: .image, url: url, thumbnail: nil)
                            self.mediaItems.append(mediaItem)
                            self.mediaCountLbl.text = "\(self.mediaItems.count)/10"
                            self.imageListCV.reloadData()
                            LoaderView.shared.hideLoader()
                            if self.mediaItems.count > 0 {
                                self.uploadImageBgView.isHidden = true
                                self.imageListCV.isHidden = false
                            } else {
                                self.uploadImageBgView.isHidden = false
                                self.imageListCV.isHidden = true
                            }
                        case .failure(let error):
                            LoaderView.shared.hideLoader()
                            print("Upload failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
        } else if item.hasItemConformingToTypeIdentifier("public.movie") {
            item.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard let url = url else { return }
                DispatchQueue.main.async {
                    LoaderView.shared.showLoader(in: self.view)
                }
                var thumbnailImage: UIImage? = nil
                self.generateThumbnail(from: url) { thumbnail in
                    if let thumbnail = thumbnail {
                        DispatchQueue.main.async {
                            thumbnailImage = thumbnail // Set thumbnail to UIImageView
                        }
                    }
                }
                self.uploadMediaToS3(fileURL: url) { result in
                    switch result {
                    case .success(let url):
                        print("Video uploaded to S3: \(url)")
                        debugPrint(url, "awsS3ImageUrl")
                       
                        let mediaItem = MediaItem(type: .video, url: url, thumbnail: thumbnailImage)
                        self.mediaItems.append(mediaItem)
                        self.mediaCountLbl.text = "\(self.mediaItems.count)/10"
                        self.imageListCV.reloadData()
                        LoaderView.shared.hideLoader()
                        if self.mediaItems.count > 0 {
                            self.uploadImageBgView.isHidden = true
                            self.imageListCV.isHidden = false
                        } else {
                            self.uploadImageBgView.isHidden = false
                            self.imageListCV.isHidden = true
                        }
                    case .failure(let error):
                        LoaderView.shared.hideLoader()
                        print("Upload failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func saveImageToDocuments(image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
//    func saveVideoToDocuments(videoURL: URL) -> URL {
//        let fileName = UUID().uuidString + ".mov"
//        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
//
//        do {
//            try FileManager.default.copyItem(at: videoURL, to: fileURL)
//            return fileURL
//        } catch {
//            print("Error saving video: \(error)")
//            return videoURL
//        }
//    }
    // MARK: - Cancel Selection
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
}
// MARK: - Uploade Server Methods
extension ConfirmDeliveryVC {
    func uploadMediaToS3(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let fileName = UUID().uuidString + "." + fileURL.pathExtension
        let s3Key = "\(fileName)" // Change folder if needed

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { _, progress in
            print("Upload Progress: \(progress.fractionCompleted * 100)%")
        }
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadFile(fileURL, bucket: BUCKET_NAME, key: s3Key, contentType: fileURL.pathExtension == "mp4" ? "video/mp4" : "image/jpeg", expression: expression) { task, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                let uploadedURL = "\(SERVERURL)/\(s3Key)"
                DispatchQueue.main.async {
                    completion(.success(uploadedURL))
                }
            }
        }
    }
    func convertMovToMp4(sourceURL: URL, completion: @escaping (URL?) -> Void) {
        let avAsset = AVURLAsset(url: sourceURL)

        // Set output file URL
        let fileName = UUID().uuidString + ".mp4"
        let exportURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        // Set export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil)
            return
        }

        exportSession.outputURL = exportURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true

        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(exportURL)
            } else {
                print("Video conversion failed: \(String(describing: exportSession.error))")
                completion(nil)
            }
        }
    }
    func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true // Ensures correct orientation

        let time = CMTime(seconds: 1, preferredTimescale: 600) // Capture frame at 1 second
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
            if let cgImage = cgImage {
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } else {
                print("Thumbnail generation failed: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
