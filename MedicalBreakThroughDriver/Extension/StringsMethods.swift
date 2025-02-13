//
//  StringsMethods.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 30/01/25.
//

import Foundation
import UIKit

func getCurrentTimeFormatted() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a" // 9:30 AM format
 //   let timeString = formatter.string(from: Date())

//    let calendar = Calendar.current
//    if calendar.isDateInToday(Date()) {
//        return "Today, \(timeString)"
//    } else {
        formatter.dateFormat = "EEEE, h:mm a" // Example: Monday, 9:30 AM
        return formatter.string(from: Date())
   // }
}
func getCurrentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    return dateFormatter.string(from: Date())
}

func convertDateFormat(dateString: String, from inputFormat: String, to outputFormat: String = "MMM dd, yyyy", timeZone: TimeZone = .current) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inputFormat
    dateFormatter.timeZone = timeZone
    
    // Convert string to Date
    guard let date = dateFormatter.date(from: dateString) else { return nil }
    
    // Convert Date to new format
    dateFormatter.dateFormat = outputFormat
    return dateFormatter.string(from: date)
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension UIViewController
{
    func showToast(message:String)
    {
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.height - 125, width: self.view.frame.width - 20, height: 35))
        //        toastLabel.backgroundColor = UIColor(named: "Primary Color")
        toastLabel.backgroundColor = UIColor(named: "707070")
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 13.0)
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 18
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations:
                            {
                toastLabel.alpha = 0.0
                
            }) { (isCompleted) in
                toastLabel.removeFromSuperview()
            }
        }
    }
}

func formatDate(_ date: Date, format: String = "dd-MM-yyyy", timeZone: TimeZone = .current) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = timeZone
    return dateFormatter.string(from: date)
}
