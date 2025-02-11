//
//  ProofOfDeliveryVC.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 31/01/25.
//

import UIKit

class ProofOfDeliveryVC: UIViewController {
    
    
    @IBOutlet weak var bgTextView: UIView!
    @IBOutlet weak var imageListCV: UICollectionView!
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var signatureImageView: UIImageView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    
    var imageListArray: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSignatureUI()
        setupCollectionView()
        // Do any additional setup after loading the view.
        signatureImageView.isHidden = true
        signatureView.isHidden = false
        bgTextView.layer.cornerRadius = 5
        bgTextView.layer.borderWidth = 1
        bgTextView.layer.borderColor = UIColor.gray.cgColor
    }
    func setupSignatureUI() {
        
        // Add Signature View
        signatureView.layer.cornerRadius = 5
        signatureView.layer.borderColor = UIColor.gray.cgColor
        signatureView.layer.borderWidth = 1
        
        // Add Clear Button
        clearButton.addTarget(self, action: #selector(clearSignature), for: .touchUpInside)
        clearButton.layer.cornerRadius = 5
        // Add Save Button
        saveButton.addTarget(self, action: #selector(saveSignature), for: .touchUpInside)
        saveButton.layer.cornerRadius = 5
    }
    func setupCollectionView() {
        imageListCV.delegate = self
        imageListCV.dataSource = self
        imageListCV?.register(UINib(nibName: "ImageListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageListCollectionViewCell")
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clearSignature() {
        signatureView.clear()
        signatureView.isHidden = false
        signatureImageView.isHidden = true
        signatureImageView.image = nil // Clear the preview as well
    }
    
    @objc func saveSignature() {
        if let image = signatureView.getImage() {
            if signatureView.isHidden == false {
                signatureView.isHidden = true
                signatureImageView.isHidden = false
                signatureImageView.image = image
            }
            //            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            //            let alert = UIAlertController(title: "Saved", message: "Signature saved to Photos.", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(alert, animated: true)
        }
    }
    @objc func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func deleteImage(_ sender: UIButton) {
        imageListArray.remove(at:sender.tag)
        imageListCV.reloadData()
    }
    @IBAction func DoneBtnAct(_ sender: UIButton) {
        let homeVC = MAIN.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
extension ProofOfDeliveryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            //  itemimageView.image = selectedImage
            imageListArray.append(selectedImage)
            imageListCV.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ProofOfDeliveryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageListArray.count == 0 {
            return 1
        } else if imageListArray.count == 5 {
            return imageListArray.count
        }
        return imageListArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCollectionViewCell", for: indexPath) as! ImageListCollectionViewCell
        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
        cell.bgView.layer.borderWidth = 1
        cell.imgView.layer.cornerRadius = 5
        if imageListArray.count == 0 {
            cell.takePhotoBtn.isHidden = false
            cell.deleteImgBtn.isHidden = true
            cell.imgView.image = nil
        } else {
            if indexPath.row == imageListArray.count {
                cell.takePhotoBtn.isHidden = false
                cell.deleteImgBtn.isHidden = true
                cell.imgView.image = nil
            } else {
                cell.takePhotoBtn.isHidden = true
                cell.deleteImgBtn.isHidden = false
                cell.imgView.image = imageListArray[indexPath.row]
            }
        }
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
        CollectionViewHeight.constant = itemWidth + 10
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
