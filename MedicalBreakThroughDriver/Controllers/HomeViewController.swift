//
//  HomeViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var noOrdersLbl: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ordersListTableView: UITableView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var dates = [Date]()
    let calendar = Calendar.current
    var selectedIndexPath: IndexPath?
    var selectedMonthIndex = 0
    var selectedYear = Calendar.current.component(.year, from: Date())
    var years: [Int] = []
    var clikedYear = false
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var ordersArray: [Order] = []
    var topTitle = "Orders"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = topTitle
        let currentYear = Calendar.current.component(.year, from: Date())
                // Generate an array of years from the current year to the past
        for year in stride(from: currentYear, to: 1900, by: -1) {
            years.append(year)
        }
        setupTableView()
        setupCollectionView()
        generateDates()
        pickerContainerView.isHidden = true
        getOrdersListApi(date: "29-11-2024")//getCurrentDate())
       // getOrdersListApi(date: getCurrentDate())
        debugPrint(PersistenceStorage.sharedInstance.driverProfileData?.accessToken ?? "", "accessToken")
    }
    // MARK: - Setup Collection View
    func setupCollectionView() {
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView?.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.decelerationRate = .fast
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func calendarBtnAct(_ sender: UIButton) {
        let calendarVC = CalendarPopupViewController()
        calendarVC.modalPresentationStyle = .popover
        if let popover = calendarVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
       // present(calendarVC, animated: true, completion: nil)
    }
    // MARK: - Setup Table View
    func setupTableView() {
        ordersListTableView.delegate = self
        ordersListTableView.dataSource = self
        ordersListTableView.register(MyOrdersListTableViewCell.self)
    }
    // MARK: - Setup DATES
    func generateDates() {
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return }
        
        dates = range.compactMap { calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: $0)) }
        
        // Set current date as default selected date
        if let currentIndex = dates.firstIndex(where: { calendar.isDate($0, inSameDayAs: currentDate) }) {
            selectedIndexPath = IndexPath(item: currentIndex, section: 0)
            DispatchQueue.main.async {
                self.calendarCollectionView.reloadData()
                self.scrollToSelectedDate(animated: false)
            }
        }
        updateMonthYearLabels(for: dates.first!)
    }
    func updateMonthYearLabels(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy"
        yearLabel.text = dateFormatter.string(from: date)
    }
    func scrollToSelectedDate(animated: Bool) {
        if let indexPath = selectedIndexPath {
            calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }
    // MARK: - Load Dates
    func loadDates(for month: Int, year: Int) {
        // Save current content offset before reloading
     //   let currentOffset = calendarCollectionView.contentOffset.x
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return }
        dates = range.compactMap { calendar.date(from: DateComponents(year: year, month: month, day: $0)) }
        debugPrint(dates,"range.compactMap")
        // Remove any selected date
        selectedIndexPath = nil
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
            // Restore the previous content offset (scroll position)
//            self.calendarCollectionView.setContentOffset(CGPoint(x: currentOffset, y: 0), animated: false)
            self.calendarCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
        // Update labels
        updateMonthYearLabels(for: firstDayOfMonth)
    }
    @IBAction func monthBtnAct(_ sender: UIButton) {
        pickerContainerView.isHidden = false
        clikedYear = false
        pickerViewSetup()
    }
    @IBAction func yearBtnAct(_ sender: UIButton) {
        pickerContainerView.isHidden = false
        clikedYear = true
        pickerViewSetup()
    }
    @IBAction func donePickerBtnAct(_ sender: UIButton) {
        loadDates(for:selectedMonthIndex+1, year: selectedYear)
        debugPrint("month: \(selectedMonthIndex+1), year: \(selectedYear)")
        pickerContainerView.isHidden = true
    }
    @IBAction func cancelPickerBtnAct(_ sender: UIButton) {
        pickerContainerView.isHidden = true
    }
    func getOrdersListApi(date: String){
        LoaderView.shared.showLoader(in: self.view)
        HomeViewModel.shared.getOrdersListAPI(date: date) { data, status, msg  in
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
}

// MARK: - Collection View Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        let date = dates[indexPath.item]
        let day = calendar.component(.day, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Get short day name (Sun, Mon, etc.)
        let weekday = dateFormatter.string(from: date).prefix(1).uppercased() // Get first letter
        
        let isSelected = indexPath == selectedIndexPath
        let isToday = calendar.isDate(date, inSameDayAs: Date())
        cell.configure(day: day, isSelected: isSelected, isToday: isToday, weekday: weekday)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
        scrollToSelectedDate(animated: true)
        updateMonthYearLabels(for: dates[indexPath.item])
       // self.getOrdersListApi(date:"29-11-2024")//formatDate(dates[indexPath.item]))
        self.getOrdersListApi(date:formatDate(dates[indexPath.item]))
    }
    // Update month & year when scrolling
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let firstVisibleIndexPath = calendarCollectionView.indexPathsForVisibleItems.min() {
//            updateMonthYearLabels(for: dates[firstVisibleIndexPath.item])
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 7  // Show 7 items
        let spacing: CGFloat = 0      // Adjust spacing if needed
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: calendarCollectionView.frame.height)
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
        cell.confirmedBtnNavi = {
            let orderVC = MAIN.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderVC = MAIN.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        orderVC.orderData = ordersArray[indexPath.row]
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
// MARK: - Picker View Methods
extension HomeViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func pickerViewSetup(){
        pickerView.delegate = self
        pickerView.dataSource = self
        // Initially position the picker container off-screen (bottom)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
    }
    // UIPickerView DataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clikedYear ? years.count : months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clikedYear ? "\(years[row])" : months[row]
    }
    
    // UIPickerView Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if clikedYear {
            selectedYear = years[row]
            debugPrint("Selected year: \(years[row])")
        } else {
            selectedMonthIndex = row
            debugPrint("Selected month: \(row)")
        }
    }
}
