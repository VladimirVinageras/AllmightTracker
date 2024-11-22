//
//  StatisticsViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.05.2024.
//

import Foundation
import UIKit

final class StatisticsViewController : UIViewController {
    //MARK: - UI ELEMENTS
    private let statisticsTableView : UITableView
    private let imageToShow : UIImage?
    private let textToShow : String
    private let emptyMainScreeView : EmptyMainScreenView
    
    //MARK:- UI VARIABLES
    private let cellIdentifier : String
    private let trackerRecordStore : TrackerRecordStore
    
    //NAV BAR ELEMENTS & VARIABLES
    private var navigationBar = UIView()
    private let screenTitle = UILabel()

    init() {
        statisticsTableView = UITableView(frame: .zero)
        imageToShow  = UIImage(named: "emptyStatsImage")
        textToShow = dictionaryUI.statisticsViewEmptyViewText
        emptyMainScreeView = EmptyMainScreenView(imageToShow: imageToShow, textToShow: textToShow)
        cellIdentifier = "statisticsTableViewCell"
        trackerRecordStore = TrackerRecordStore()
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.trackerWhite
        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self
        prepareUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadingView()
    }
    
    private func prepareNavigationBar(){ 
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        screenTitle.text = dictionaryUI.tabBarStatistics
        screenTitle.textColor = .trackerBlack
        screenTitle.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(screenTitle)
        
        NSLayoutConstraint.activate([
            screenTitle.heightAnchor.constraint(equalToConstant: 41),
            screenTitle.widthAnchor.constraint(equalToConstant: 254),
            screenTitle.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 44),
            screenTitle.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -53),
            screenTitle.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16)
        ])
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 138)
        ])
    }
    
    func loadingView(){
        for view in view.subviews{
            view.removeFromSuperview()
        }
        prepareNavigationBar()
        
        if getAmountOfRecords() == 0 {
            view.addSubview(emptyMainScreeView)
            emptyMainScreeView.prepareStarMainScreen()
            NSLayoutConstraint.activate([
                emptyMainScreeView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
                emptyMainScreeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                emptyMainScreeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                emptyMainScreeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
        }else {
            view.addSubview(statisticsTableView)
            NSLayoutConstraint.activate([
                statisticsTableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
                statisticsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                statisticsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
                statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 24)
            ])
        }
        statisticsTableView.reloadData()
    }
    
    func getAmountOfRecords() -> Int {
        let amountOfRecords : Int
        do{
       amountOfRecords = try trackerRecordStore.fetchTrackerRecords().count
        }catch{
            fatalError(TrackerRecordStoreError.decodingErrorInvalidFetch.localizedDescription)
        }
        return amountOfRecords
    }
    
    func prepareUIElements(){
        statisticsTableView.translatesAutoresizingMaskIntoConstraints = false
        statisticsTableView.register(StatisticsViewCell.self, forCellReuseIdentifier: cellIdentifier)
        statisticsTableView.backgroundColor = UIColor.trackerWhite
        emptyMainScreeView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StatisticsViewCell else { return StatisticsViewCell() }
        cell.updateParameterTitle(with: dictionaryUI.statisticsViewParameterTitle)
        cell.updateCountLabelText(with: getAmountOfRecords())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
