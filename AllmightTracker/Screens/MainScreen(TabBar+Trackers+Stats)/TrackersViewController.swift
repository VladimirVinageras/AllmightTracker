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

    private let trackerDateLabel: UILabel = {
        let label = UILabel()
        label.layer.frame = CGRect(x: 0, y: 0, width: 77, height: 34)
        label.layer.backgroundColor = UIColor.trackerLightGray.cgColor
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.isUserInteractionEnabled = true

        return label
    }()
    
    private lazy var trackerDatePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.layer.backgroundColor = UIColor.trackerWhite.cgColor
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.datePickerMode = .date
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.layer.cornerRadius = 13
        datePicker.layer.shadowColor = UIColor.lightGray.cgColor
        datePicker.layer.shadowOpacity = 0.2
        datePicker.layer.shadowOffset = CGSize(width: 0, height: 0)
        datePicker.layer.shadowRadius = 10
        return datePicker
    }()
    
    
    private let addTrackerButton = UIButton()
    
    
    
    private let trackerSearchField = UISearchTextField()
    private let starImageView = UIImageView()
    private let starLabel = UILabel()
    private let screenTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        prepareNavigationBar()
        prepareStarMainScreen()
        prepareDateUIItems()
        activateConstraints()
    }
    func prepareDateUIItems(){
        let currentDate = Date()
        updateLabel(with: currentDate)
        view.addSubview(trackerDatePicker)
        trackerDatePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        trackerDateLabel.addGestureRecognizer(tapGesture)
        trackerDatePicker.isHidden = true
    }
    
    @objc func dateLabelTapped() {
        trackerDatePicker.isHidden = false
        view.bringSubviewToFront(trackerDatePicker)
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        updateLabel(with: sender.date)
        trackerDatePicker.isHidden = true
        view.sendSubviewToBack(trackerDatePicker)
    }
    
    func updateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        trackerDateLabel.text = dateFormatter.string(from: date)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: trackerDateLabel)
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
            trackerDatePicker.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 7),
            trackerDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

}
