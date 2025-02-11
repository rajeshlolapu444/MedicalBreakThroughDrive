//
//  DateSelectionViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 11/02/25.
//

import UIKit

class DateSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    let datePicker = UIDatePicker()
    let pickerVieww = UIPickerView()
    
    var startDate: Date?
    var endDate: Date?
    var availableEndDates: [Date] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the initial start date (default to today)
        startDate = Date()
        
        //        // Setup pickers
        //        pickerView.delegate = self
        //        pickerView.dataSource = self
        //
        //        setupDatePicker()
    }
    //    func setupDatePicker() {
    //           datePicker.datePickerMode = .date
    //           datePicker.preferredDatePickerStyle = .wheels
    //       }
    
    @IBAction func startDateTapped(_ sender: UIButton) {
        showDatePicker(isStartDate: true)
    }
    
    @IBAction func endDateTapped(_ sender: UIButton) {
        showDatePicker(isStartDate: false)
    }
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
                   datePicker.minimumDate = Date()
               } else {
                   datePicker.minimumDate = Date()
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
                   self.startDateButton.setTitle(self.formatDate(selectedDate), for: .normal)
                   
                   // When Start Date is selected, update the End Date picker to show future dates
                   if let endDate = self.endDate {
                      // self.updateEndDatePicker(minimumDate: selectedDate, maxDate: endDate)
                   }
               } else {
                   self.endDate = selectedDate
                   self.endDateButton.setTitle(self.formatDate(selectedDate), for: .normal)
                   
                   // When End Date is selected, update the Start Date picker to show dates before the selected end date
                   if let startDate = self.startDate {
                      // self.updateStartDatePicker(minimumDate: startDate, maxDate: selectedDate)
                   }
               }
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true)
       }
              
       // Format Date
       func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter.string(from: date)
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
        endDateButton.setTitle(formatDate(endDate!), for: .normal)
    }
}
