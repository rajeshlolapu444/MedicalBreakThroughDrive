//
//  ProfileViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit
import Photos
import AppTrackingTransparency

class ProfileViewController: UIViewController {

    @IBOutlet weak var topEditBtnBgView: UIView!
    @IBOutlet weak var firstEditIconImg: UIImageView!
    @IBOutlet weak var lastEditIconImg: UIImageView!
    @IBOutlet weak var emailNotEditIconImg: UIImageView!
    @IBOutlet weak var phoneEditIconImg: UIImageView!
    @IBOutlet weak var profileImgEditBtnBgView: UIView!
    @IBOutlet weak var profileImgEditBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var changePasswordStackView: UIStackView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    var isProfile = false
    var pickImage = UIImage()
    var profileImgeUrl = ""
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isProfile {
            profileStackView.isHidden = false
            changePasswordStackView.isHidden = true
            self.titleLbl.text = "Profile"
            self.conditionsForHide(isHide: true)
            self.profileImgEditBtn.addTarget(self, action: #selector(requestTrackingPermission), for: .touchUpInside)
            self.updateBtn.addTarget(self, action: #selector(updateBtnAct), for: .touchUpInside)
            self.topEditBtnBgView.isHidden = false
            if PersistenceStorage.sharedInstance.driverProfileData != nil {
                self.setupData()
            } else {
                profileDataApiCall()
            }
        } else {
            profileStackView.isHidden = true
            changePasswordStackView.isHidden = false
            self.titleLbl.text = "Change Password"
            self.topEditBtnBgView.isHidden = true
        }
    }
    func setupData() {
        let data = PersistenceStorage.sharedInstance.driverProfileData
        self.firstNameTF.text = data?.firstName
        self.lastNameTF.text = data?.lastName
        self.emailTF.text = data?.email
        if data?.phone == "" || data?.phone == nil {
            self.phoneNumberTF.text = ""
        } else {
            let usFormate = formatPhoneNumberUSA(data?.phone ?? "")
            self.phoneNumberTF.text = usFormate
        }
        self.profileImgeUrl = data?.profileImage ?? ""
        profileImgView.setImage(from: data?.profileImage ?? "")
    }
    func profileDataApiCall() {
        LoaderView.shared.showLoader(in: self.view)
        ProfileViewModel.shared.getDriverProfileAPI { status, msg in
            if status {
                if let data = PersistenceStorage.sharedInstance.driverProfileData {
                    debugPrint(data, "driverProfileData")
                    LoaderView.shared.hideLoader()
                    self.setupData()
                }
            } else {
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
            }
        }
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editBtnAct(_ sender: UIButton) {
        self.conditionsForHide(isHide: false)
        self.titleLbl.text = "Edit Profile"
    }
    
    @IBAction func changePasswordBtnAct(_ sender: UIButton) {
        self.changePasswordAPiCall()
    }
    func conditionsForHide(isHide: Bool) {
        self.updateBtn.isHidden = isHide
        self.firstNameTF.isUserInteractionEnabled = !isHide
        self.lastNameTF.isUserInteractionEnabled = !isHide
        self.phoneNumberTF.isUserInteractionEnabled = !isHide
        self.phoneNumberTF.keyboardType = .numbersAndPunctuation
        self.firstEditIconImg.isHidden = true
        self.lastEditIconImg.isHidden = true
        self.emailNotEditIconImg.isHidden = true
        self.phoneEditIconImg.isHidden = true
        self.profileImgEditBtnBgView.isHidden = isHide
        if !isHide {
            self.emailTF.textColor = UIColor.lightGray
        } else {
            self.emailTF.textColor = UIColor.black
        }
    }
    @objc func updateBtnAct() {
//        if firstNameTF.text == "" {
//            self.showToast(message: "Please enter first name.")
//            return
//        } else if lastNameTF.text == "" {
//            self.showToast(message: "Please enter last name.")
//            return
//        } else if phoneNumberTF.text == ""{
//            self.showToast(message: "Please enter phone number.")
//            return
//        } else {
//            
//        }
        let firstName = firstNameTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let lastName = lastNameTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let phoneNumber = phoneNumberTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let params = UpdateProfileRequestModel(first_name: firstName, last_name: lastName, phone: phoneNumber, profile_image: self.profileImgeUrl)
        debugPrint(params,"params")
        LoaderView.shared.showLoader(in: self.view)
        ProfileViewModel.shared.updatePutAPICall(params: params) { status, msg in
            self.showToast(message: msg ?? "")
            if status {
                ProfileViewModel.shared.getDriverProfileAPI { status, msg in
                    LoaderView.shared.hideLoader()
                    //self.navigationController?.popViewController(animated: true)
                    self.conditionsForHide(isHide: true)
                }
            } else {
                LoaderView.shared.hideLoader()
            }
        }
    }
}

extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func btnProfileImageTapped(){
        let alertView = UIAlertController(title: "Please choose one", message: nil, preferredStyle: .actionSheet)
             let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
                 AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                     if response {
                         DispatchQueue.main.async {
                             let picker = UIImagePickerController()
                             picker.sourceType = .camera
                             picker.mediaTypes = ["public.image"]
                             picker.delegate = self
                             picker.allowsEditing = true
                             AppUtils.presentOnRootViewController(picker)

                         }
                     } else {
                         DispatchQueue.main.async {
                             let alertView = UIAlertController(title: "Purpose of Camera Access?", message: "To capture  a photo/video and upload as profile image & proof of delivery, this app requires access to your camera. Please enable permissions in your device settings to continue.", preferredStyle: .alert)
                             let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                                 alertView.dismiss(animated: true, completion: nil)
                             }
//                             let allowNowAction: UIAlertAction = UIAlertAction(title: "Allow Now", style: .default) { action -> Void in
//                                 UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                             }
                             alertView.addAction(cancelAction)
                             //alertView.addAction(allowNowAction)
                             AppUtils.presentOnRootViewController(alertView)
                         }
                     }
                 }
             }
             let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
                 self.galleryOpen()
     
             }
             let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
             }
     
             alertView.addAction(cameraAction)
             alertView.addAction(photoLibraryAction)
             alertView.addAction(cancelAction)
        AppUtils.presentOnRootViewController(alertView)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.profileImgView.image = pickedImage
            self.profileImgView.contentMode = .scaleToFill
//            self.profileImg2.image = pickedImage
//            self.profileImg2.contentMode = .scaleAspectFit
            self.pickImage = pickedImage
            self.uploadImageAWS(UploadImage: pickImage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
    }
//
    func uploadImageAWS(UploadImage:UIImage){
        LoaderView.shared.showLoader(in: self.view)
        AWSS3Manager.shared.uploadImage(image: UploadImage, progress: { [weak self] (progress) in
            guard let strongSelf = self else { return }
            debugPrint(strongSelf)
        }) { [weak self] (uploadedFileUrl, error) in
            LoaderView.shared.hideLoader()
            guard let strongSelf = self else { return }
            debugPrint(strongSelf)
            if let awsS3Url = uploadedFileUrl as? String {
               debugPrint("Uploaded file url: " + awsS3Url)
                let awsS3Url = SERVERURL + awsS3Url
//                self?.arrMediaUpload.insert(awsS3Url, at: 0)
               debugPrint("upload image url --",awsS3Url)
                self!.profileImgeUrl = awsS3Url
                //self?.updateProfileAPICall()
                //self?.updateOnlyProfile()

            } else {
                debugPrint("\(String(describing: error?.localizedDescription))")
                var rootVC = UIViewController()
                if #available(iOS 15.0, *) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        rootVC = keyWindow.rootViewController ?? UIViewController()
                    }
                } else {
                    rootVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController ?? UIViewController()
                }
                rootVC.showToast(message: error!.localizedDescription)
            }
        }
    }
    func galleryOpen(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.openPhotos()
            break
        case .denied, .restricted :
            DispatchQueue.main.async {
                let alertView = UIAlertController(title: "Purpose of Photo library Access?", message: "To upload profile image and  proof of delivery which is already available on your device, this app requires access to your photo library. Please enable permissions in your device settings to continue.", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                    alertView.dismiss(animated: true, completion: nil)
                }
//                let allowNowAction: UIAlertAction = UIAlertAction(title: "Allow Now", style: .default) { action -> Void in
//                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                }
                alertView.addAction(cancelAction)
               // alertView.addAction(allowNowAction)
//                let rootVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
//                rootVC?.present(alertView, animated: true, completion: nil)
                AppUtils.presentOnRootViewController(alertView)

            }
            break
        case .limited:
            self.openPhotos()
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                            let picker = UIImagePickerController()
                            picker.sourceType = .photoLibrary
                            picker.mediaTypes = ["public.image"]
                            picker.delegate = self
                            picker.allowsEditing = true
                            self.present(picker, animated: true)
                        }
                    }
                    break
                case .limited:
                    self.openPhotos()
                    break
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        let alertView = UIAlertController(title: "Purpose of Photo library Access?", message: "To upload profile image and  proof of delivery which is already available on your device, this app requires access to your photo library. Please enable permissions in your device settings to continue.", preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
                            alertView.dismiss(animated: true, completion: nil)
                        }
//                        let allowNowAction: UIAlertAction = UIAlertAction(title: "Allow Now", style: .default) { action -> Void in
//                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                        }
                        alertView.addAction(cancelAction)
                       // alertView.addAction(allowNowAction)
//                        let rootVC = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
//                        rootVC?.present(alertView, animated: true, completion: nil)
                        AppUtils.presentOnRootViewController(alertView)

                    }
                    break
                case .notDetermined:
                    break
                    
                @unknown default:
                    break
                }
            }
            
        @unknown default:
            break
        }
        
        
    }
    func openPhotos(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.mediaTypes = ["public.image"]
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true)
            }
        }
    }
}
extension ProfileViewController {
    func changePasswordAPiCall() {
        if oldPasswordTF.text == "" {
            self.showToast(message: "Please enter old password.")
            return
        } else if newPasswordTF.text == "" {
            self.showToast(message: "Please enter new password.")
            return
        } else if confirmPasswordTF.text == ""{
            self.showToast(message: "Please enter confirm password.")
            return
        } else {
            if newPasswordTF.text != confirmPasswordTF.text {
                self.showToast(message: "New password and confirm password does not match.")
                return
            }
        }
        let oldPassword = oldPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let newPassword = newPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let confirmPassword = confirmPasswordTF.text?.replacingOccurrences(of: " ", with: "") ?? ""
        LoaderView.shared.showLoader(in: self.view)
        let params = ChangePasswordRequestModel(old_password: oldPassword, new_password: newPassword, new_password_confirmation: confirmPassword)
        ProfileViewModel.shared.changePasswordAPICall(params: params) { status, msg in
            LoaderView.shared.hideLoader()
            self.showToast(message: msg ?? "")
            if status {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.popOrPushToViewController(ofType: LoginViewController.self)
                }
            }
        }
    }
}

class AppUtils {
    /// Presents a view controller on the root view controller of the key window.
    static func presentOnRootViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            debugPrint("Unable to find the root view controller.")
            return
        }
        
        DispatchQueue.main.async {
            rootVC.present(viewController, animated: animated, completion: completion)
        }
    }
}
extension ProfileViewController {
    func showTrackingPermissionPopup() {
        let alert = UIAlertController(
            title: "Privacy Notice",
            message: "We use your data to improve your experience. Please allow tracking.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            self.requestTrackingPermission()
        })

        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: nil))

        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true)
        }
    }
    @objc func requestTrackingPermission() {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized")
                    self.btnProfileImageTapped()
                case .denied, .restricted, .notDetermined:
                    print("Tracking denied")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       // self.showTrackingDeniedAlert()
                    }
                @unknown default:
                    print("Unknown status")
                }
            }
        }
    func showTrackingDeniedAlert() {
        let alert = UIAlertController(
            title: "Purpose of Tracking permission Access?",
            message: "To ensure a smooth app experience, we rely on app tracking to collect essential crash reports and performance data. This helps us maintain and improve the app regularly. Please enable tracking in your device settings to support ongoing enhancements.",
            preferredStyle: .alert
        )
//        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
//            self.openAppSettings()
//        })

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        AppUtils.presentOnRootViewController(alert)
    }
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
