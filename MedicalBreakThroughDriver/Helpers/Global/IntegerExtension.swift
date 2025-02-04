//
//  IntegerExtension.swift
//  Done
//
//  Created by Tarun Sahu on 29/03/24.
//

import Foundation

extension Int {
func withCommas() -> String {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      numberFormatter.locale = Locale(identifier: "en_US")
      return numberFormatter.string(from: NSNumber(value:self))!
  }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
