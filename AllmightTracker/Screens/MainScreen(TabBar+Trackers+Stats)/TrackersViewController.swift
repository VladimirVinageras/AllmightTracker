//
//  TrackersViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.05.2024.
//

import Foundation
import UIKit

final class TrackersViewController : UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private let addTrackerButton = UIButton()
    private lazy var trackerDatePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.tintColor = .trackerBlue
        datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private let trackerSearchField = UISearchTextField()
    private let starImageView = UIImageView()
    private let starLabel = UILabel()
    private let screenTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        prepareNavigationBar()
        prepareStarMainScreen()
     //   dateValueChanged(_:)
        activateConstraints()
    }
    
    
    private func prepareNavigationBar(){
       
        addTrackerButton.setImage(UIImage(named: "navBarAddIcon"), for: .normal)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
     
       
        
        
        
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        screenTitle.text = "Трекеры"
        screenTitle.textColor = .trackerBlack
        screenTitle.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        
        trackerSearchField.translatesAutoresizingMaskIntoConstraints = false
        trackerSearchField.placeholder = "Поиск"
        
        view.addSubview(trackerSearchField)
        view.addSubview(screenTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: trackerDatePicker)
    }
    
    @objc private func dateValueChanged(_ sender: UIDatePicker){
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
    }
    
    @objc private func plusButtonTapped() {
   present(AddNewTrackerViewController(), animated: true)
    }
    
    
    private func prepareStarMainScreen(){
       
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = UIImage(named: "StarMainScreen")
        starImageView.frame.size = CGSize(width: 80, height: 80)
        
       
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.text = "Что будем отслеживать?"
        starLabel.textColor = .trackerBlack
        starLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        view.addSubview(starImageView)
        view.addSubview(starLabel)
    }
    
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerSearchField.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 7),
            trackerSearchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerSearchField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            starImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImageView.topAnchor.constraint(equalTo: trackerSearchField.bottomAnchor, constant: 220),
            starImageView.heightAnchor.constraint(equalToConstant: 80),
            starImageView.widthAnchor.constraint(equalToConstant: 80),
            starLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
            starLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
        ])
    }

}
