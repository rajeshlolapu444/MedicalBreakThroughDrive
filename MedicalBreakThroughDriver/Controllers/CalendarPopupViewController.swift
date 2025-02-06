//
//  CalendarPopupViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 06/02/25.
//

import UIKit

class CalendarPopupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    var monthLabel: UILabel!
    var currentMonth: Int = Calendar.current.component(.month, from: Date())
    var currentYear: Int = Calendar.current.component(.year, from: Date())
    var currentDay: Int = Calendar.current.component(.day, from: Date())
    var daysInMonth: [Date] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadDaysInMonth()
    }
    
    func setupUI() {
        monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.boldSystemFont(ofSize: 18)
        monthLabel.textColor = .black
        view.addSubview(monthLabel)
        
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("◀", for: .normal)
        leftButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        view.addSubview(leftButton)
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("▶", for: .normal)
        rightButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        view.addSubview(rightButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 40, height: 40)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leftButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            rightButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func loadDaysInMonth() {
        daysInMonth.removeAll()
        selectedIndexPath = nil
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        if let firstDay = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: firstDay) {
            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                    daysInMonth.append(date)
                }
            }
        }
        monthLabel.text = "\(DateFormatter().monthSymbols[currentMonth - 1]) \(currentYear)"
        collectionView.reloadData()
    }
    
    @objc func previousMonth() {
        currentMonth -= 1
        if currentMonth < 1 {
            currentMonth = 12
            currentYear -= 1
        }
        loadDaysInMonth()
    }
    
    @objc func nextMonth() {
        currentMonth += 1
        if currentMonth > 12 {
            currentMonth = 1
            currentYear += 1
        }
        loadDaysInMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for subview in cell.contentView.subviews { subview.removeFromSuperview() }
        
        let date = daysInMonth[indexPath.item]
        let day = Calendar.current.component(.day, from: date)
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "\(day)"
        label.frame = cell.contentView.bounds

        cell.contentView.addSubview(label)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.height / 2

        if indexPath == selectedIndexPath {
            cell.backgroundColor = UIColor.systemGreen
            label.textColor = .white
        } else if day == currentDay && currentMonth == Calendar.current.component(.month, from: Date()) && currentYear == Calendar.current.component(.year, from: Date()) {
            cell.backgroundColor = UIColor.systemBlue
            label.textColor = .white
        } else {
            cell.backgroundColor = .white
            label.textColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let selectedDate = daysInMonth[indexPath.item]
        print("Selected date: \(selectedDate)")
        collectionView.reloadData()
    }
}
