//
//  AddNewTrackerSchedule.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit

final class AddNewTrackerScheduleViewController : UIViewController {
    var selectedDaysBefore: [ScheduleDay]  = []
    var cellDaysSelected = [ScheduleDay]()
    var daysSelected = [String]()
    
    var scheduleViewControllerDelegate : ScheduleViewControllerProtocol?
    let trackerScheduleCellReuseIdentifier = "scheduleTableViewCell"
    
    
    private let scheduleViewTitle: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.text = dictionaryUI.addNewScheduleTitle
        viewTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitle.textColor = .trackerBlack
        return viewTitle
    }()
    
    private let scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let scheduleDoneButton : UIButton = {
        let scheduleButton = UIButton(type: .custom)
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle(dictionaryUI.addNewScheduleBtnReady, for: .normal)
        scheduleButton.setTitleColor(.trackerWhite, for: .normal)
        scheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        scheduleButton.backgroundColor = .trackerBlack
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.addTarget(self, action: #selector(scheduleDoneButtonTapped), for: .touchUpInside)
        return scheduleButton
        
    }()
    
    @objc private func scheduleDoneButtonTapped(){
        let selectedShortDays = selectedShortDays()
        scheduleViewControllerDelegate?.updateEventSelectedDays(with: selectedShortDays, and: cellDaysSelected)
        dismiss(animated: true)
    }
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        for dayIndex in 0..<7 {
            let weekDay = ScheduleDay(scheduleDay: Weekday.allCases[dayIndex], isScheduled: false)
            cellDaysSelected.append(weekDay)
        }
        view.backgroundColor = .trackerWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
super.viewDidLoad()
        addSubviews()
        activateConstraints()
        prepareScheduleTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       selectedDaysBefore =  scheduleViewControllerDelegate?.checkingSelectedDays() ?? []
        updateCellDaysSelected()
        scheduleTableView.reloadData()
        daysSelected.removeAll()
    }
    
    private func updateCellDaysSelected() {
        cellDaysSelected.removeAll()
        for dayIndex in 0..<7 {
            var weekDay: ScheduleDay?
            if selectedDaysBefore.isEmpty || selectedDaysBefore == nil{
                weekDay  = ScheduleDay(scheduleDay: Weekday.allCases[dayIndex], isScheduled: false)
            }else{
                weekDay = ScheduleDay(scheduleDay: selectedDaysBefore[dayIndex].scheduleDay, isScheduled: selectedDaysBefore[dayIndex].isScheduled)
            }
            if let weekDay = weekDay{
                cellDaysSelected.append(weekDay)
            }
        }
    }
    
    
    func prepareScheduleTableView(){
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.register(NewTrackerScheduleTableViewCell.self, forCellReuseIdentifier: trackerScheduleCellReuseIdentifier)
    }
    
    func addSubviews(){
        view.addSubview(scheduleViewTitle)
        view.addSubview(scheduleTableView)
        view.addSubview(scheduleDoneButton)
    }

    func activateConstraints(){
        NSLayoutConstraint.activate([
            scheduleViewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            scheduleViewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleTableView.topAnchor.constraint(equalTo: scheduleViewTitle.bottomAnchor, constant: 30),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 524),
            scheduleDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scheduleDoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scheduleDoneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            scheduleDoneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
     func selectedShortDays() -> String {
       var selectedShortDaysArray: [String] = []

        for dayIndex in 0..<7 {
            if self.cellDaysSelected[dayIndex].isScheduled {
                let shortName = self.cellDaysSelected[dayIndex].scheduleDay.shortDaysName
                    selectedShortDaysArray.append(shortName)
                }
            }
    return selectedShortDaysArray.joined(separator: ", ")
    }

}

extension AddNewTrackerScheduleViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddNewTrackerScheduleViewController :  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: trackerScheduleCellReuseIdentifier,
                                                       for: indexPath) as? NewTrackerScheduleTableViewCell else {return NewTrackerScheduleTableViewCell()}
        cell.cellDelegate = self
        cell.setupWeekday(with: cellDaysSelected[indexPath.row])
        return cell
    }
}


extension AddNewTrackerScheduleViewController : ScheduleCellProtocol {
    func updateDayStatus(to day: ScheduleDay, with newStatus: Bool) {
            cellDaysSelected[day.scheduleDay.rawValue - 1] = day
    }
}





