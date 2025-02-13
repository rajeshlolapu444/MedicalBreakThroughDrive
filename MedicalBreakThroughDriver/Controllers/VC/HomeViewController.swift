//
//  HomeViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = topTitle
        setupTableView()
        debugPrint(PersistenceStorage.sharedInstance.loginResponseData?.accessToken ?? "", "accessToken")
        self.notesPoupViewSetup()
        self.startDateLabel.text = formatDate(Date(), format: "MMM dd, yyyy")
        self.endDateLabel.text = formatDate(Date(), format: "MMM dd, yyyy")
        startDate = Date()
       // endDate = Date()
        if ordersType == .Active {
            let sDate = formatDate(Date(), format: "dd-MM-yyyy")
            let eDate = formatDate(Date(), format: "dd-MM-yyyy")
            self.getActiveOrdersList(startDate: sDate, endDate: eDate)
            self.notesSaveBtn.isHidden = false
            self.notesTextView.isUserInteractionEnabled = true
            self.endDateBgView.isHidden = true
            startDateTitleLbl.text = "Date"
        } else {
            let sDate = formatDate(Date(), format: "dd-MM-yyyy")
            let eDate = formatDate(Date(), format: "dd-MM-yyyy")
            self.getPastOrdersList(startDate: sDate, endDate: eDate)
            self.notesSaveBtn.isHidden = true
            self.notesTextView.isUserInteractionEnabled = false
            self.endDateBgView.isHidden = false
            startDateTitleLbl.text = "Start Date :"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.notesPopupView.isHidden = true
    }
    func notesPoupViewSetup() {
        self.notesTextViewBgView.layer.borderColor = UIColor.lightGray.cgColor
        self.notesTextViewBgView.layer.borderWidth = 1
    }

    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func calendarBtnAct(_ sender: UIButton) {
        let vc = GoogleMapViewController()
        vc.isfromHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Setup Table View
    func setupTableView() {
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
    func getActiveOrdersList(startDate: String,endDate: String){
        LoaderView.shared.showLoader(in: self.view)
        HomeViewModel.shared.getActiveOrdersListAPI(start_date: startDate, end_date: endDate) { data, status, msg in
            if status {
                LoaderView.shared.hideLoader()
                self.ordersArray = data ?? []
                debugPrint(self.ordersArray,"ordersArray")
                self.noOrdersLbl.isHidden = !self.ordersArray.isEmpty
                self.ordersListTableView.reloadData()
            } else {
                self.noOrdersLbl.isHidden = false
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
            }
        }
    }
    func getPastOrdersList(startDate: String,endDate: String){
        LoaderView.shared.showLoader(in: self.view)
        HomeViewModel.shared.getPastOrdersListAPI(start_date: startDate, end_date: endDate) { data, status, msg in
            if status {
                LoaderView.shared.hideLoader()
                self.ordersArray = data ?? []
                debugPrint(self.ordersArray,"ordersArray")
                self.noOrdersLbl.isHidden = !self.ordersArray.isEmpty
                self.ordersListTableView.reloadData()
            } else {
                self.noOrdersLbl.isHidden = false
                self.showToast(message: msg ?? "")
                LoaderView.shared.hideLoader()
            }
        }
    }
    @IBAction func notePopupCloseBtnAct(_ sender: UIButton) {
        self.notesPopupView.isHidden = true
    }
    @IBAction func notesSaveBtnAct(_ sender: UIButton) {
        if notesTextView.text != "" {
            HomeViewModel.shared.notesAPICall(id: self.selectedOrderID, notes: notesTextView.text ?? "") { status, msg in
                self.showToast(message: msg ?? "")
                if status {
                    self.notesTextView.text = ""
                    self.notesPopupView.isHidden = true
                }
            }
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
        cell.loadData(data: orderData)
        cell.notesBtn = {
            self.notesPopupView.isHidden = false
            self.notesTitleLbl.text = "Add notes for order #\(orderData.orderID ?? 0)"
            self.selectedOrderID = orderData.id ?? 0
            self.notesTextView.text = orderData.deliveryDetails?.notes ?? ""
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
    
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func showDatePicker(isStartDate: Bool) {
           let alertVC = UIViewController()
           alertVC.preferredContentSize = CGSize(width: 340, height: 250) // Adjust height to prevent overlap
           
           let datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
           datePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 200) // Set proper size
           
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
               } else {
                   datePicker.minimumDate = Date()
               }
           }
           
           alertVC.view.addSubview(datePicker)
           
           let alert = UIAlertController(title: isStartDate ? "Select Start Date" : "Select End Date", message: nil, preferredStyle: .alert)
           
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
                   self.getActiveOrdersList(startDate: startDateString, endDate: endDateString)
               } else {
                   self.getPastOrdersList(startDate: startDateString, endDate: endDateString)
               }
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true)
       }
              
//       // Format Date
//       func formatDate(_ date: Date) -> String {
//           let formatter = DateFormatter()
//           formatter.dateFormat = "yyyy-MM-dd"
//           return formatter.string(from: date)
//       }
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
