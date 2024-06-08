//
//  TrackersViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.05.2024.
//

import Foundation
import UIKit

final class TrackersViewController : UIViewController {
    static var shared = TrackersViewController()
//MARK: - MOCK DATA

    //Categories will equal to [] initially, after BD implementation
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Важно", trackers: [
            Tracker(id: UUID(), name: "Спать каждый день", color: .colorSelection3, emoji: "😪", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .thursday, isScheduled: true)])),
            
            Tracker(id: UUID(), name: "Кушать каждый день", color: .colorSelection10, emoji: "❤️", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .friday, isScheduled: true)])),
            Tracker(id: UUID(), name: "Отдыхать каждый день", color: .colorSelection6, emoji: "🐥", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .sunday, isScheduled: true)])),
            
            Tracker(id: UUID(), name: "Гулять каждый день", color: .colorSelection9, emoji: "🌺", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .tuesday, isScheduled: true)])),
            
            Tracker(id: UUID(), name: "Смеяться каждый день", color: .colorSelection14, emoji: "😃", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .saturday, isScheduled: true)]))]
                       ),
        
        TrackerCategory(title: "Очень Важно", trackers: [
            Tracker(id: UUID(), name: "Спать ", color: .colorSelection1, emoji: "🐶", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .wednesday, isScheduled: true)])),
            
            Tracker(id: UUID(), name: "Кушать", color: .colorSelection15, emoji: "🍔", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .monday, isScheduled: true)])),
            Tracker(id: UUID(), name: "Смеяться ", color: .colorSelection12, emoji: "🙂", schedule: TrackerSchedule(id: UUID(), isAnHabit: false, scheduledDays: [ ScheduleDay(scheduleDay: .sunday, isScheduled: true)]))]
                       )
    ]
//MARK: - STORE VARIABLES
    private var trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    
//MARK: - UI VARIABLES
    var isActiveDateFiltering : Bool = false
    var isTryingToChangeTheFuture : Bool = false
    var dateForFiltering: Date?
    var filteredCategories : [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    var collectionViewDelegate : UICollectionViewDelegateFlowLayout?
    let trackersCollectionViewCellIdentifier = "trackersCollectionViewCellIdentifier"
    let headerSectionIdentifier = "header"
    
    private let trackerDateLabel: UILabel = {
        let label = UILabel()
        label.layer.frame = CGRect(x: 0, y: 0, width: 77, height: 34)
        label.layer.backgroundColor = UIColor.trackerSuperLightGray.cgColor
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    private lazy var trackerDatePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.layer.backgroundColor = UIColor.trackerWhite.cgColor
        
        ///Этот вариант был единственный способ которое я нашел для решение задачи с формата дата "dd.MM.yy" и чтобы
        ///оно польностью совпадало с макетой. Альтернативный вариант было бы в ручную с помошью UICollectionView создать
        ///собственный календарь но это не простая задача в уже и так объемный Спринт.
        ///Решение была согласована с наставником.
        ///Прекрасного дня и хорошоего настроение  ;-)
    
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.preferredDatePickerStyle = .compact
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
    
    private var containerViewHolder : UIView = {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .trackerWhite
        container.clipsToBounds = true
        return container
    }()
    
    private let scrollView: UIScrollView = {
        let scrllView = UIScrollView()
        scrllView.translatesAutoresizingMaskIntoConstraints = false
        scrllView.isScrollEnabled = true
        return scrllView
    }()
    
    private let vStack : UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.spacing = 16
        return vstack
    }()
    
    private let addTrackerButton = UIButton()
    private let trackerSearchField = UISearchTextField()
    private let starImageView = UIImageView()
    private let starLabel = UILabel()
    private let screenTitle = UILabel()
 
//MARK: - INITs and VIEWDIDLOAD
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        trackerCategoryStore.delegate = self
        
     let tempCategories = try? trackerCategoryStore.fetchTrackers()
         categories = tempCategories ?? categories
        
        filteredCategories = categories
        prepareNavigationBar()
        prepareDateUIItems()
        view.addSubview(containerViewHolder)
        activateConstraints()
        setupContainerView()
        setupContainerHolder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: Notification.Name("ReloadTrackersViewController"), object: nil)
        
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReloadTrackersViewController"), object: nil)
    }

//MARK: - @OBJC Functions
    
    @objc private func reloadView() {
        
        setupContainerView()
        setupContainerHolder()
    }
    
    @objc func dateLabelTapped() {
        trackerDatePicker.isHidden = false
        view.bringSubviewToFront(trackerDatePicker)
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        updateLabel(with: sender.date)
        isActiveDateFiltering = true
        dateForFiltering = sender.date
        if let dateForFiltering = dateForFiltering {
            isTryingToChangeTheFuture = Date() < dateForFiltering
        }
        trackerDatePicker.isHidden = true
        view.sendSubviewToBack(trackerDatePicker)
        reloadView()
    }
    
    @objc private func plusButtonTapped() {
        present(AddNewTrackerViewController(), animated: true)
    }
    
//MARK: - Setups , Constraints
    private func prepareDateUIItems(){
        let currentDate = Date()
        updateLabel(with: currentDate)
        view.addSubview(trackerDatePicker)
        
        trackerDatePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        trackerDateLabel.addGestureRecognizer(tapGesture)
        trackerDatePicker.isHidden = true
    }
    
    private func updateLabel(with date: Date) {
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
        trackerSearchField.frame = CGRect(origin: .zero, size: CGSize(width: 288, height: 36))
        trackerDateLabel.backgroundColor = .trackerLightGray12
        
        view.addSubview(trackerSearchField)
        view.addSubview(screenTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: trackerDateLabel)
    }
    
    private func prepareStarMainScreen(){
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.image = UIImage(named: "StarMainScreen")
        starImageView.frame.size = CGSize(width: 80, height: 80)
        
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.text = "Что будем отслеживать?"
        starLabel.textColor = .trackerBlack
        starLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerSearchField.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 7),
            trackerSearchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerSearchField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            trackerSearchField.heightAnchor.constraint(equalToConstant: 36),
            trackerDatePicker.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 7),
            trackerDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerViewHolder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerViewHolder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            containerViewHolder.topAnchor.constraint(equalTo: trackerSearchField.bottomAnchor, constant: 24),
            containerViewHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupContainerView(){
        for view in containerViewHolder.subviews{
            view.removeFromSuperview()
        }
        containerViewHolder.removeConstraints(containerViewHolder.constraints)
        
        if categories.isEmpty{
            starLabel.isHidden = false
            starImageView.isHidden = false
            prepareStarMainScreen()
            containerViewHolder.addSubview(starImageView)
            containerViewHolder.addSubview(starLabel)
            
            NSLayoutConstraint.activate([
                starImageView.centerXAnchor.constraint(equalTo: containerViewHolder.centerXAnchor),
                starImageView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor, constant: 246),
                starImageView.heightAnchor.constraint(equalToConstant: 80),
                starImageView.widthAnchor.constraint(equalToConstant: 80),
                starLabel.centerXAnchor.constraint(equalTo: starImageView.centerXAnchor),
                starLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            ])
        }
        else
        {
            starLabel.isHidden = true
            starImageView.isHidden = true
            containerViewHolder.addSubview(scrollView)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: containerViewHolder.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: containerViewHolder.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: containerViewHolder.trailingAnchor)
            ])
        }
    }
    
    private func setupContainerHolder(){
        for view in vStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        filteredCategories = filteringEventsByDate(from: categories)
        
        for category in filteredCategories {
            let layout = UICollectionViewFlowLayout()
            let newTrackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            newTrackerCollectionView.tag = filteredCategories.firstIndex(of: category) ?? 0
            prepareTrackersCollectionView(for: newTrackerCollectionView)
            vStack.addArrangedSubview(newTrackerCollectionView)
            let collectionHeight = CGFloat((category.trackers.count / 2 + category.trackers.count % 2) * 148 + 30) // Refactoring gonna be later 😉 🐝
            NSLayoutConstraint.activate([
                newTrackerCollectionView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                newTrackerCollectionView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                newTrackerCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionHeight))
            ])
            newTrackerCollectionView.reloadData()
            
            print("🙈🙈🙈🙈🙈Category: \(category.title)")
            for tracker in category.trackers {
                print("      🙈🙈🙈 Tracker: \(tracker.name)")
            }
            
        }
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func prepareTrackersCollectionView(for trackersCollectionView: UICollectionView){
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 149, height: 34)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 7
        layout.scrollDirection = .vertical
        
        trackersCollectionView.collectionViewLayout = layout
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionView.allowsMultipleSelection = false
        trackersCollectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: trackersCollectionViewCellIdentifier)
        trackersCollectionView.register(MainHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerSectionIdentifier + "\(trackersCollectionView.tag)")
        trackersCollectionView.isScrollEnabled = false
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
    }
    
    //MARK: - FilteringEventsByDate
    
    private func filteringEventsByDate(from categories: [TrackerCategory]) -> [TrackerCategory]{
        
        guard let dateForFiltering = dateForFiltering else {return categories}
        
        let selectedWeekday = Weekday(from: dateForFiltering)
        
        let repCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let scheduledDays = tracker.schedule.scheduledDays else { return false }
                return scheduledDays.contains { $0.scheduleDay == selectedWeekday && $0.isScheduled }
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        for category in repCategories {
            print("Category: \(category.title)")
            for tracker in category.trackers {
                print(" Tracker: \(tracker.name)")
            }
        }
        return repCategories
    }
    
    
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TrackersViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoryIndex = collectionView.tag
        return filteredCategories[categoryIndex].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackersCollectionViewCellIdentifier, for: indexPath) as? TrackerViewCell else {return TrackerViewCell()}
        let categoryIndex = collectionView.tag
        let currentEvent = filteredCategories[categoryIndex].trackers[indexPath.item]
        let eventTitle = currentEvent.name
        let color = currentEvent.color
        let emoji = currentEvent.emoji
        let completedTask = completedTrackers.contains { $0.idCompletedTracker == currentEvent.id }
        
        cell.prepareDataForUsing(color: color, eventTitle: eventTitle, emoji: emoji, completedTask: completedTask)
        cell.preventingChangesInFuture(isNecesary: isTryingToChangeTheFuture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerSectionIdentifier + "\(collectionView.tag)", for: indexPath) as? MainHeaderCollectionView else { return MainHeaderCollectionView()}
        let categoryIndex = collectionView.tag
        header.titleLabel.text = filteredCategories[categoryIndex].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 3.5, height: 149)
    }
}

//MARK: TrackersViewControllerProtocol
extension TrackersViewController : TrackersViewControllerProtocol {
    
    func saveNewTracker(with newCategoryName: String, for newEvent: Tracker) {
        
        do {
            try trackerCategoryStore.saveTrackerToCategory(tracker: newEvent, in: newCategoryName)
            dateForFiltering = nil
        } catch {
            print("Error saving new tracker: \(error)")
        }
        
//        var eventsInCategory: [Tracker] = []
//        for category in self.categories {
//            if category.title == newCategoryName {
//                eventsInCategory = category.trackers
//                categories.removeAll(where: {$0.title == category.title})
//            }
//        }
//        eventsInCategory.append(newEvent)
//        let newTrackerCategory = TrackerCategory(title: newCategoryName, trackers: eventsInCategory)
//        categories.append(newTrackerCategory)
//        
//        for category in self.categories {
//            print(category.title + "\n \n")
//            for tracker in category.trackers {
//                print(tracker.name + "\n")
//            }
//        }
//        
//       try? trackerCategoryStore.addNewTrackerCategory(newTrackerCategory)
//       dateForFiltering = nil
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func storeRecord() {
        completedTrackers = trackerRecordStore.trackerRecords
        reloadView()
    }
}

extension TrackersViewController : TrackerCategoryStoreDelegate {
    func storeCategoryDidChange() {
        guard let fetchedCategories = try? trackerCategoryStore.fetchTrackers() else {return}
        self.categories = fetchedCategories
               self.setupContainerView()
               self.setupContainerHolder()
       }
}






