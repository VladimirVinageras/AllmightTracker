//
//  NewTrackerScheduleTableViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit


final class NewTrackerScheduleTableViewCell : UITableViewCell {
    
    private var day: ScheduleDay = ScheduleDay(scheduleDay: .sunday, isScheduled: false)
    var cellDelegate : ScheduleCellProtocol?
    
    private let weekday: UILabel = {
        let weekDay = UILabel()
        weekDay.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        weekDay.translatesAutoresizingMaskIntoConstraints = false
        return weekDay
    }()
    
    private var weekdaySwitch : UISwitch = {
       let daySwitch = UISwitch()
        daySwitch.onTintColor = .trackerBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        daySwitch.addTarget(self, action: #selector(daySwitchTapped), for: .touchUpInside)
        return daySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .trackerBackgroundDay
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
    
    @objc private func daySwitchTapped(){
        day.isScheduled.toggle()
        cellDelegate?.updateDayStatus(to: day, with: weekdaySwitch.isOn)
    }
    
    func setupWeekday(with day: ScheduleDay){
        self.day = day
        weekday.text = day.scheduleDay.name
        weekdaySwitch.setOn(day.isScheduled, animated: true)
    }
}

