//
//  HomeViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var routeBtnBgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var startDateBgView: UIView!
    @IBOutlet weak var endDateBgView: UIView!
    @IBOutlet weak var startDateTitleLbl: UILabel!
    @IBOutlet weak var noOrdersLbl: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var ordersListTableView: UITableView!
    @IBOutlet weak var notesPopupView: UIView!
    @IBOutlet weak var notesTitleLbl: UILabel!
    @IBOutlet weak var notesTextViewBgView: UIView!
    @IBOutlet weak var notesSaveBtn: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    var ordersArray: [Order] = []
    var topTitle = "Orders"
    
    let datePicker = UIDatePicker()
    let pickerVieww = UIPickerView()
    
    var startDate: Date?
    var endDate: Date?
    var availableEndDates: [Date] = []
    var ordersType: OrdersType?
    var selectedOrderID : Int?
    
    var currentPage:Int = 1
    var isFetching = false
    var hasMoreData = true
    let placeholderTextView = "Add your Notes..."
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if we need to request location again
        let shouldRequest = UserDefaults.standard.bool(forKey: "RequestLocationOnHomePage")
        if shouldRequest {
            UserDefaults.standard.set(false, forKey: "RequestLocationOnHomePage") // Reset flag
            LocationManager.shared.requestLocationOnHomePage { coordinate in
                if let coordinate = coordinate {
                    print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                    PersistenceStorage.sharedInstance.currentLocationCoordinates = coordinate
                } else {
                    print("Location access denied")
                }
            }
        }

        
        self.titleLbl.text = topTitle
        setupTableView()
        debugPrint(PersistenceStorage.sharedInstance.loginResponseData?.accessToken ?? "", "accessToken")
        self.notesPoupViewSetup()
       
        orderTypeSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.notesPopupView.isHidden = true
    }
    func notesPoupViewSetup() {
        self.notesTextViewBgView.layer.borderColor = UIColor.lightGray.cgColor
        self.notesTextViewBgView.layer.borderWidth = 1
    }
    func orderTypeSetup() {
        let sDate = formatDate(Date(), format: "dd-MM-yyyy")
        let eDate = formatDate(Date(), format: "dd-MM-yyyy")
                 

        if ordersType == .Active {
            startDate = Date()
           // endDate = Date()
            self.startDateLabel.text = formatDate(Date(), format: "MMM dd, yyyy")
            fetchActiveOrders(startDate: sDate, endDate: eDate)
            self.notesSaveBtn.isHidden = false
            self.notesTextView.isUserInteractionEnabled = true
            self.endDateBgView.isHidden = true
            startDateTitleLbl.text = "Date"
            startDateTitleLbl.isHidden = true
            self.routeBtnBgView.isHidden = false
        } else {
            startDate = nil
            endDate = nil

            self.startDateLabel.text = "Start Date"
            self.endDateLabel.text = "End Date"
            fetchPastOrders(startDate: "", endDate: "")
            self.notesSaveBtn.isHidden = true
            self.notesTextView.isUserInteractionEnabled = false
            self.endDateBgView.isHidden = false
            startDateTitleLbl.isHidden = true
            startDateTitleLbl.text = "Start Date :"
            self.routeBtnBgView.isHidden = true
        }
    }

    func fetchPastOrders(startDate: String?, endDate: String?) {
        guard !isFetching else { return }
        isFetching = true
        LoaderView.shared.showLoader(in: self.view)
        HomeViewModel.shared.getPastOrdersListAPI(start_date: startDate, end_date: endDate, page: currentPage) { newOrders, status, msg in
            DispatchQueue.main.async {
                if status, let newOrders = newOrders {
                    if newOrders.isEmpty {
                        self.hasMoreData = false
                        LoaderView.shared.hideLoader()
                    } else {
                        self.ordersArray.append(contentsOf: newOrders)
                        self.currentPage += 1
                        LoaderView.shared.hideLoader()
                    }
                } else {
                    self.hasMoreData = false
                    LoaderView.shared.hideLoader()
                }
                LoaderView.shared.hideLoader()
                self.isFetching = false
                self.ordersListTableView.reloadData()
                if self.ordersArray.count == 0 {
                    self.noOrdersLbl.isHidden = false
                } else {
                    self.noOrdersLbl.isHidden = true
                }
            }
        }
    }
    func fetchActiveOrders(startDate: String?, endDate: String?) {
            guard !self.isFetching else { return }
            self.isFetching = true
            LoaderView.shared.showLoader(in: self.view)
            HomeViewModel.shared.getActiveOrdersListAPI(start_date: startDate, end_date: endDate, page: self.currentPage) { newOrders, status, msg in
                DispatchQueue.main.async {
                    if status, let newOrders = newOrders {
                        if newOrders.isEmpty {
                            self.hasMoreData = false
                            LoaderView.shared.hideLoader()
                        } else {
                            self.ordersArray.append(contentsOf: newOrders)
                            self.currentPage += 1
                            LoaderView.shared.hideLoader()
                        }
                    } else {
                        self.hasMoreData = false
                        LoaderView.shared.hideLoader()
                    }
                    LoaderView.shared.hideLoader()
                    self.isFetching = false
                    self.ordersListTableView.reloadData()
                    if self.ordersArray.count == 0 {
                        self.noOrdersLbl.isHidden = false
                    } else {
                        self.noOrdersLbl.isHidden = true
                    }
                }
            }
    }

    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func routeBtnAct(_ sender: UIButton) {
        if ordersArray.count > 0 {
            var destinations = [CLLocationCoordinate2D]()
            for i in 0..<ordersArray.count {
                let lat = ordersArray[i].address?.latitude ?? 0.0
                let longi = ordersArray[i].address?.longitude ?? 0.0
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude:longi)
                destinations.append(coordinate)
            }
            let vc = MapGoogleViewController()
            vc.destinations = destinations
            vc.isFromHome = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    // MARK: - Setup Table View
    func setupTableView() {
        //ordersListTableView.contentInsetAdjustmentBehavior = .never
        ordersListTableView.contentInset = .zero
        ordersListTableView.sectionHeaderHeight = 0
        //ordersListTableView.translatesAutoresizingMaskIntoConstraints = false
        ordersListTableView.delegate = self
        ordersListTableView.dataSource = self
        ordersListTableView.register(MyOrdersListTableViewCell.self)
    }
    @IBAction func monthBtnAct(_ sender: UIButton) {
       // pickerContainerView.isHidden = false
       // clikedYear = false
        //pickerViewSetup()
        showDatePicker(isStartDate: true)
    }
    @IBAction func yearBtnAct(_ sender: UIButton) {
        //pickerContainerView.isHidden = false
       // clikedYear = true
        //pickerViewSetup()
        showDatePicker(isStartDate: false)
    }
    @IBAction func notePopupCloseBtnAct(_ sender: UIButton) {
        self.notesPopupView.isHidden = true
    }
    @IBAction func notesSaveBtnAct(_ sender: UIButton) {
        if notesTextView.text != "" && notesTextView.text != placeholderTextView{
            HomeViewModel.shared.notesAPICall(id: self.selectedOrderID, notes: notesTextView.text ?? "") { status, msg in
                self.showToast(message: msg ?? "")
                if status {
                    self.notesTextView.text = ""
                    self.notesPopupView.isHidden = true
                }
            }
        } else {
            self.showToast(message: "The notes field is required")
        }
    }
    func callNumber(number:String) {
            let phoneNumber = number // Change this to your number
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cannot open dialer")
            }
        }
}
// MARK: - Table View Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: MyOrdersListTableViewCell.self)
        cell.selectionStyle = .none
        let orderData = ordersArray[indexPath.row]
        cell.loadData(data: orderData,ordersType:ordersType ?? .Active)
        cell.numberBtn = {
            self.callNumber(number: orderData.customer?.phone ?? "")
        }
        cell.notesBtn = {
            self.notesPopupView.isHidden = false
            self.notesTitleLbl.text = "Add notes for order #\(orderData.orderID ?? 0)"
            self.selectedOrderID = orderData.id ?? 0
            self.notesTextView.delegate = self
            let notes = orderData.deliveryDetails?.notes ?? ""
            if notes == "" {
                self.notesTextView.text = self.placeholderTextView
                self.notesTextView.textColor = UIColor.lightGray
            } else {
                self.notesTextView.textColor = UIColor.black
                self.notesTextView.text = orderData.deliveryDetails?.notes ?? ""
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderVC = MAIN.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        orderVC.orderData = ordersArray[indexPath.row]
        orderVC.orderType = ordersType
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !hasMoreData {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel(frame: footerView.bounds)
            label.isHidden = ordersArray.count == 0
            label.text = "No more data"
            label.textColor = .gray
            label.textAlignment = .center
            footerView.addSubview(label)
            return footerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return hasMoreData ? 0 : 50
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.height

        if offsetY > contentHeight - tableViewHeight - 100, hasMoreData {
            let startDateString = formatDate(self.startDate ?? Date(), format: "dd-MM-yyyy")
            let endDateString = formatDate(self.endDate ?? Date(), format: "dd-MM-yyyy")
            if ordersType == .Active {
                self.fetchActiveOrders(startDate: startDateString, endDate: endDateString)
            } else {
                if self.endDateLabel.text == "End Date" || self.startDateLabel.text == "Start Date"{
                    self.fetchPastOrders(startDate: "", endDate: "")
                } else {
                    self.fetchPastOrders(startDate: startDateString, endDate: endDateString)
                }
            }
        }
    }

}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func showDatePicker(isStartDate: Bool) {
           let alertVC = UIViewController()
           alertVC.preferredContentSize = CGSize(width: 340, height: 260) // Adjust height to prevent overlap
           
           let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
           datePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 210) // Set proper size
           if isStartDate {
               // If Start Date is selected, allow selecting current date to future dates
               //datePicker.minimumDate = Date()
               if let endDate = endDate {
                   datePicker.maximumDate = endDate // Ensure end date is after start date
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd-MM-yyyy"
                   if let minDate = dateFormatter.date(from: "01-01-2013") {
                       datePicker.minimumDate = minDate
                   }
               } else {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd-MM-yyyy"
                   if let minDate = dateFormatter.date(from: "01-01-2013") {
                       datePicker.minimumDate = minDate
                   }
                   datePicker.maximumDate = Date()
               }
           } else {
               // If End Date is selected, allow selecting current date to future dates
               if let startDate = startDate {
                   datePicker.minimumDate = startDate // Ensure end date is after start date
                   datePicker.maximumDate = Date()
               } else {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd-MM-yyyy"
                   if let minDate = dateFormatter.date(from: "01-01-2013") {
                       datePicker.minimumDate = minDate
                   }
                   datePicker.maximumDate = Date()
               }
           }
           
           alertVC.view.addSubview(datePicker)
           
        let alert = UIAlertController(title: isStartDate ? (ordersType == .Active ? "Select Date" : "Select Start Date") : "Select End Date", message: nil, preferredStyle: .alert)
           
           alert.setValue(alertVC, forKey: "contentViewController") // Embed picker in alert
           
           alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
               let selectedDate = datePicker.date
               if isStartDate {
                   self.startDate = selectedDate
                   self.startDateLabel.text = formatDate(selectedDate, format: "MMM dd, yyyy")
               } else {
                   self.endDate = selectedDate
                   self.endDateLabel.text = formatDate(selectedDate, format: "MMM dd, yyyy")
               }
               let startDateString = formatDate(self.startDate ?? Date(), format: "dd-MM-yyyy")
               let endDateString = formatDate(self.endDate ?? Date(), format: "dd-MM-yyyy")

               if self.ordersType == .Active {
                   self.ordersArray.removeAll()
                   self.currentPage = 1
                   self.isFetching = false
                   self.hasMoreData = true
                   self.fetchActiveOrders(startDate: startDateString, endDate: endDateString)
               } else {
                   self.ordersArray.removeAll()
                   self.currentPage = 1
                   self.isFetching = false
                   self.hasMoreData = true
                   if self.endDateLabel.text == "End Date" || self.startDateLabel.text == "Start Date"{
                       //self.showToast(message: "Please selecte start and end dates")
                   } else {
                       self.fetchPastOrders(startDate: startDateString, endDate: endDateString)
                   }
               }
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true)
       }
    func updateAvailableEndDates() {
        guard let startDate = startDate else { return }
        
        availableEndDates.removeAll()
        var nextDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        
        for _ in 1...30 {
            availableEndDates.append(nextDate)
            nextDate = Calendar.current.date(byAdding: .day, value: 1, to: nextDate)!
        }
        
        pickerVieww.reloadAllComponents()
    }
    
    
    // MARK: - UIPickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableEndDates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formatDate(availableEndDates[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        endDate = availableEndDates[row]
    }
}
extension HomeViewController:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderTextView {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderTextView
            textView.textColor = UIColor.lightGray
        }
    }
}
