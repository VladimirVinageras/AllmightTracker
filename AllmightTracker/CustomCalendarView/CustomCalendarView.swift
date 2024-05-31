//
//  CustomCalendarView.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 23.05.2024.
//

import Foundation
import UIKit

class CustomCalendarView: UIView {
    
    var onDateSelected: ((Date) -> Void)?
    private let calendar = Calendar.current
    private var selectedDate = Date()
    private let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CalendarDateCell.self, forCellWithReuseIdentifier: "customsCalendarCollectionViewCell")
        collectionView.backgroundColor = .trackerWhite
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        activateConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        addSubview(calendarCollectionView)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
    }
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            calendarCollectionView.topAnchor.constraint(equalTo: topAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendarCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    private func dateForCell(at indexPath: IndexPath) -> Date {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let weekday = calendar.component(.weekday, from: startOfMonth) - calendar.firstWeekday
        let daysOffset = (indexPath.item - weekday + 7) % 7
        return calendar.date(byAdding: .day, value: daysOffset, to: startOfMonth)!
    }
}
extension CustomCalendarView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customsCalendarCollectionViewCell", for: indexPath) as? CalendarDateCell else {return CalendarDateCell()}
        cell.backgroundColor = .lightGray
        let date = dateForCell(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        cell.dateLabel.text = dateFormatter.string(from: date)
        return cell}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = Date()
        onDateSelected?(date)}
}

extension CustomCalendarView : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height / 6
        return CGSize(width: width, height: height)
    }
}

