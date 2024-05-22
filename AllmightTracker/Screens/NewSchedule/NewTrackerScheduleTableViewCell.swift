//
//  NewTrackerScheduleTableViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit


final class NewTrackerScheduleTableViewCell : UITableViewCell {
    var selectedWeekday: Bool = false
    
    private let weekday: UILabel = {
        let weekDay = UILabel()
        weekDay.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        weekDay.translatesAutoresizingMaskIntoConstraints = false
        return weekDay
    }()
    
    private lazy var weekdaySwitch : UISwitch = {
       let daySwitch = UISwitch()
        daySwitch.onTintColor = .trackerBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.addTarget(self, action: #selector(daySwitchTapped), for: .touchUpInside)
        return daySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .trackerLightGray.withAlphaComponent(0.3)
        contentView.addSubview(weekday)
        contentView.addSubview(weekdaySwitch)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            weekday.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weekday.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekdaySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weekdaySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func daySwitchTapped(_ sender: UISwitch){
        self.selectedWeekday = sender.isOn
    }
    
    func updateWeekdayTitle(with title: String){
        weekday.text = title
    }    
}

