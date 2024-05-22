//
//  AddNewTrackerSchedule.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit

final class AddNewTrackerScheduleViewController : UIViewController {
    
    let trackerScheduleCellReuseIdentifier = "scheduleTableViewCell"
    var createHabitViewControllerDelegate: ScheduleViewControllerProtocol?
    
    private let scheduleViewTitle: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.text = "Расписание"
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
        scheduleButton.setTitle("Готово", for: .normal)
        scheduleButton.setTitleColor(.trackerWhite, for: .normal)
        scheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        scheduleButton.backgroundColor = .trackerBlack
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.addTarget(self, action: #selector(scheduleDoneButtonTapped), for: .touchUpInside)
        return scheduleButton
        
    }()
    
    @objc private func scheduleDoneButtonTapped(){
        //TODO: - Save selected elements
    }
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
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
        let weekDay = Weekday.allCases[indexPath.row]
        cell.updateWeekdayTitle(with: weekDay.name)
        return cell
    }
}



