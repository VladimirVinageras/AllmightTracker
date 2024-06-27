//
//  TrackersViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 05.05.2024.
//

import Foundation
import UIKit

let dateFormatter : DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd.MM.yy"
    return df
}()


let dictionaryUI = DictionaryUI()


final class TrackersViewController : UIViewController {
    static var shared = TrackersViewController()
    
    var categories: [TrackerCategory] = []
    //MARK: - STORE VARIABLES
    private var trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    
    //MARK: - UI VARIABLES
    var isActiveDateFiltering : Bool = false
    var isActiveSearchFiltering : Bool = false
    var isTryingToChangeTheFuture : Bool = false
    var dateForFiltering: Date?
    var filteredCategories : [TrackerCategory] = []
    var filteredData : [TrackerCategory] = []
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
        label.textColor = .trackerDateLabelText
        label.isUserInteractionEnabled = true
        
        return label
    }()
    private lazy var trackerDatePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.layer.backgroundColor = UIColor.trackerWhite.cgColor
        
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
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        trackerCategoryStore.delegate = self
        
        let tempCategories = try? trackerCategoryStore.fetchTrackerCategories()
        categories = tempCategories ?? categories
        
        let tempRecords = try? trackerRecordStore.fetchTrackerRecords()
        completedTrackers = tempRecords ?? completedTrackers
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
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //MARK: - @OBJC Functions
    
    @objc private func reloadView() {
        do {
            categories = try trackerCategoryStore.fetchTrackerCategories()
            if let dateForFiltering = dateForFiltering {
                completedTrackers = try trackerRecordStore.fetchTrackerRecords().filter { record in
                    let recordDate = dateFormatter.string(from: record.dateTrackerCompleted)
                    let selectedDate = dateFormatter.string(from: dateForFiltering)
                    return recordDate == selectedDate
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        filteredCategories = filteringEventsByDate(from: categories)
        
        
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
        
        do{
            completedTrackers = try trackerRecordStore.fetchTrackerRecords().filter { record in
                let recordDate = dateFormatter.string(from: record.dateTrackerCompleted)
                let currentDate = dateFormatter.string(from: sender.date)
                return recordDate == currentDate
            }
            
            trackerDatePicker.isHidden = true
            view.sendSubviewToBack(trackerDatePicker)
            reloadView()
        }
        catch {
            print("Error fetching tracker records: \(error)")
        }
    }
    
    @objc private func plusButtonTapped() {
        present(AddNewTrackerViewController(), animated: true)
    }
    
    
    @objc private func textDidChange(_ searchField: UISearchTextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            filteredData = categories.compactMap { category -> TrackerCategory? in
                let filteredTrackers = category.trackers.filter {tracker in
                    tracker.name.lowercased().contains (searchText.lowercased())
                }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            isActiveSearchFiltering = true
        }
        else {
            filteredData = categories
        }
        categories = filteredData
        reloadView()
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
        trackerDateLabel.text = dateFormatter.string(from: date)
    }
    
    private func prepareNavigationBar(){
        addTrackerButton.setImage(UIImage(named: "navBarAddIcon"), for: .normal)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        screenTitle.text = dictionaryUI.trackersViewTitle
        screenTitle.textColor = .trackerBlack
        screenTitle.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        trackerSearchField.translatesAutoresizingMaskIntoConstraints = false
        trackerSearchField.placeholder = dictionaryUI.trackersViewSearchHolderText
        trackerSearchField.textColor = .trackerBlack
        trackerSearchField.autocapitalizationType = .none
        trackerSearchField.clearButtonMode = .whileEditing
        trackerSearchField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
        starLabel.text = dictionaryUI.trackersViewHolderText
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
        if isActiveSearchFiltering {
            filteredCategories = filteredData
            isActiveSearchFiltering = false
        }
        
        for category in filteredCategories {
            let layout = UICollectionViewFlowLayout()
            let newTrackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            newTrackerCollectionView.tag = filteredCategories.firstIndex(of: category) ?? 0
            newTrackerCollectionView.backgroundColor = .trackerWhite
            prepareTrackersCollectionView(for: newTrackerCollectionView)
            vStack.addArrangedSubview(newTrackerCollectionView)
            let collectionHeight = CGFloat((category.trackers.count / 2 + category.trackers.count % 2) * 148 + 30) // Refactoring gonna be later
            NSLayoutConstraint.activate([
                newTrackerCollectionView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                newTrackerCollectionView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                newTrackerCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionHeight))
            ])
            newTrackerCollectionView.reloadData()
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
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(dateForFiltering)
        
        let repCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let scheduledDays = tracker.schedule.scheduledDays else { return false }
                return scheduledDays.contains { $0.scheduleDay == selectedWeekday && $0.isScheduled } || !(tracker.schedule.isAnHabit) && isToday
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
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
        let eventId = currentEvent.id
        
        cell.prepareDataForUsing(color: color, eventTitle: eventTitle, emoji: emoji, trackerID: eventId, calendarDate: dateForFiltering ?? Date())
        
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {return nil}
        
        let indexPath = indexPaths[0]
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell else {
            return UIContextMenuConfiguration()
        }
        
        let actionTitle = cell.isPinHidden() ? dictionaryUI.trackersViewContextMenuPin : dictionaryUI.trackersViewContextMenuUnpin
        
        return UIContextMenuConfiguration( previewProvider: {
            [weak self] in
            cell.getTrackerCard()
        }, actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: actionTitle) { [weak self] _ in
                    if !cell.isPinHidden() {
                        self?.unPinTracker(indexPath: indexPath)
                        cell.willHidePin(is: true)
                    }
                    else{
                        self?.pinTracker(indexPath: indexPath)
                        cell.willHidePin(is: false)
                    }
                },
                UIAction(title: dictionaryUI.trackersViewContextMenuEdit) { [weak self] _ in
                    self?.editTracker(indexPath: indexPath)
                },
                UIAction(title: dictionaryUI.trackersViewContextMenuDelete, attributes: .destructive) { [weak self] _ in
                    guard let self = self else {return}
                    
                    let deleteAction  = {[weak self] in
                        guard cell.getTrackerID() != nil else {return}
                        self?.deleteTracker(indexPath: indexPath)
                    }
                    
                    let deleteConfirmationSheet = createAlert(title: "", message: dictionaryUI.trackersViewContextMenuDeleteMessage, action: deleteAction)
                    
                    self.present(deleteConfirmationSheet, animated: true)
                    
                }
            ])
        })
    }
    
    
    
    private func createAlert(title: String, message: String, action: @escaping ()-> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: dictionaryUI.trackersViewContextMenuDelete, style: .destructive){ _ in
            action()
        })
        
        alert.addAction(UIAlertAction(title: dictionaryUI.createHabitViewBtnCancelTitle, style: .cancel) {action in
            alert.dismiss(animated: true)
        })
        
        
        return alert
    }
    
    
    private func pinTracker(indexPath: IndexPath){
        let trackerId = trackerStore.trackers[indexPath.row].id
        
        do {
            try trackerStore.pinUnpinTracker(id: trackerId, with: true)
        }
        catch{
            print("Failed to update the tracker: \(error.localizedDescription)")
        }
    }
    
    private func unPinTracker(indexPath: IndexPath){
        let trackerId = trackerStore.trackers[indexPath.row].id
        
        do {
            try trackerStore.pinUnpinTracker(id: trackerId, with: false)
        }
        catch{
            print("Failed to update the tracker: \(error.localizedDescription)")
        }
    }
    
    private func editTracker(indexPath: IndexPath){
       //TODO: - IMPLEMENT the edit view
    }
    
    private func deleteTracker(indexPath: IndexPath){
        let trackerId = trackerStore.trackers[indexPath.row].id
        do {
            try  trackerStore.deleteTracker(by: trackerId)
        }
        catch{
            print("Failed trying to delete the tracker: \(error.localizedDescription)")
        }
       
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
        guard let fetchedCategories = try? trackerCategoryStore.fetchTrackerCategories() else {return}
        self.categories = fetchedCategories
        self.setupContainerView()
        self.setupContainerHolder()
    }
}







