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
    
    //MARK: - EDITING VIEWCONTROLLER HELPER VARIABLES
    var eventToUpdate : Tracker?
    var amountOfDaysText = ""
    
    //MARK: - STORE VARIABLES
    private var trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    
    //MARK: - UI VARIABLES
    
    var isTryingToChangeTheFuture : Bool = false
    var isEmptySearchResult: Bool = true
    var dateForFiltering: Date?
    
    //MARK: - ANIMATION VARIABLES
    private var upAnimationStarted = false
    private var downAnimationStarted = false
    private var isFirstScroll = true
    
    //MARK: - ARRAY Variables
    private var categories: [TrackerCategory] = []
    private var categoriesToShow : [TrackerCategory] = []
    private var filteredData : [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var unpinnedTrackers: [TrackerCategory]  = []
    private var pinCategory : TrackerCategory = TrackerCategory(title: dictionaryUI.trackersViewPinnedCategoryName, trackers: [])
    
    //MARK: - DELEGATES & IDENTIFIERS
    var collectionViewDelegate : UICollectionViewDelegateFlowLayout?
    let trackersCollectionViewCellIdentifier = "trackersCollectionViewCellIdentifier"
    let headerSectionIdentifier = "header"
    
    //MARK: - UI ELEMENTS
    private let emptyMainScreenView : EmptyMainScreenView
    private let addTrackerButton = UIButton()
    private let trackerSearchField = UISearchTextField()
    private let screenTitle = UILabel()
    private let filtersButton : UIButton = {
        let button = UIButton(type: .system )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor =  UIColor.trackerBlue.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle(dictionaryUI.trackersViewFiltersButtonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.tintColor = .trackerWhite
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
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
    
    //MARK: - FILTERING VARIABLES
    private var isCustomFilterActivated : (isFilterActivated: Bool, filter : Filters?)
    private var isActiveDateFiltering : Bool = false
    private var isActiveSearchFiltering : Bool = false
    private var areFiltersEnabled : [Bool] = [true, true, true, true]
    private var isListToShowEmpty = false
    private var listHasToBeEmpty = false
    
    //MARK: - EMPTYMAINVIEW VARIABLES
    private var hasToShowEmptyView = true
    private var imageToShow = UIImage(named: "starMainScreen")
    private var textToShow = dictionaryUI.trackersViewHolderText
    
    //MARK: - ANALYTICS - APPMETRICA
    private let appMetricAnalyticsService = AnalyticsService()
    
    //MARK: - INITIALIZATION
    init() {
        isCustomFilterActivated.isFilterActivated = false
        isCustomFilterActivated.filter = nil
        emptyMainScreenView = EmptyMainScreenView(imageToShow: imageToShow, textToShow: textToShow)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        trackerCategoryStore.delegate = self
        trackerSearchField.delegate = self
        let tempCategories = try? trackerCategoryStore.fetchTrackerCategories()
        categories = tempCategories ?? categories
        let tempRecords = try? trackerRecordStore.fetchTrackerRecords()
        completedTrackers = tempRecords ?? completedTrackers
        dateForFiltering = Date()
        prepareNavigationBar()
        prepareDateUIItems()
        view.addSubview(containerViewHolder)
        activateConstraints()
        categoriesToShow = categories
        containerViewHolder.addSubview(filtersButton)
        setupContainerView()
        setupContainerHolder()
        scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: Notification.Name("ReloadTrackersViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controlButtonColor), name: Notification.Name("ControlButtonColor"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReloadTrackersViewController"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ControlButtonColor"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appMetricAnalyticsService.mainScreenDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appMetricAnalyticsService.mainScreenDidDisappear()
    }
    
    //MARK: - @OBJC Functions
    @objc func controlButtonColor() {
        filtersButton.tintColor = isCustomFilterActivated.isFilterActivated ? .trackerRed : .trackerWhite
    }
    
    @objc private func reloadView() {
        do {
            categories = try trackerCategoryStore.fetchTrackerCategories()
            completedTrackersOnDateForFiltering()
        } catch {
            print("Error fetching data: \(error)")
        }
        setupContainerHolder()
        setupContainerView()
    }
    
    @objc func dateLabelTapped() {
        trackerDatePicker.isHidden = false
        view.bringSubviewToFront(trackerDatePicker)
    }
    
    @objc func dateValueChanged(_ sender: UIDatePicker) {
        sender.isUserInteractionEnabled = false
        updateLabel(with: sender.date)
        isActiveDateFiltering = true
        dateForFiltering = sender.date
        if let dateForFiltering = dateForFiltering {
            isTryingToChangeTheFuture = Date() < dateForFiltering
        }
        sender.isHidden = true
        view.sendSubviewToBack(trackerDatePicker)
        sender.isUserInteractionEnabled = true
        reloadView()
    }
    
    @objc private func plusButtonTapped() {
        appMetricAnalyticsService.mainScreenDidPlusButtonTap()
        present(AddNewTrackerViewController(), animated: true)
    }
    
    @objc private func filtersButtonTapped(){
        appMetricAnalyticsService.mainScreenDidFilterButtonTap()
        do{
            categories = try trackerCategoryStore.fetchTrackerCategories()
        }
        catch{
            fatalError(TrackerCategoryStoreError.decodingErrorInvalidFetch.localizedDescription)
        }
        
        unpinnedTrackers = separetingTrackers(mainList: categories)
        isCustomFilterActivated.isFilterActivated = true
        
        for filterIndex in 1..<4 {
            areFiltersEnabled[filterIndex] = !(filteringTrackersToShow(from: unpinnedTrackers, withFilter: Filters(rawValue: filterIndex))).isEmpty
        }
        
        isCustomFilterActivated.isFilterActivated = false
        
        let filterListViewController = FilterListViewController(areFiltersEnabled: areFiltersEnabled, isCustomFilterActive: isCustomFilterActivated)
        filterListViewController.delegate = self
        present(filterListViewController , animated: true)
    }
    
    @objc private func textDidChange(_ searchField: UISearchTextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            filteredData = categories.compactMap { category -> TrackerCategory? in
                let filteredTrackers = category.trackers.filter {tracker in
                    tracker.name.lowercased().contains (searchText.lowercased())
                }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            isEmptySearchResult = filteredData.isEmpty
            isActiveSearchFiltering = true
        }
        else {
            filteredData = categories
            isEmptySearchResult = true
            isActiveSearchFiltering = false
        }
        reloadView()
    }
    
    //MARK: - ANIMATIONS
    private func scrollUpButtonAnimation(){
        if !downAnimationStarted && !isFirstScroll{
            filtersButtonAnimation(buttonTransparencyToBe: 1, distanceToMove: 150)
        }
    }
    
    private func scrollDownButtonAnimation(){
        if !upAnimationStarted{
            filtersButtonAnimation(buttonTransparencyToBe: 0, distanceToMove: -150)
        }
    }
    
    func filtersButtonAnimation(buttonTransparencyToBe: CGFloat, distanceToMove: CGFloat){
        UIView.animate(withDuration: 0.25, animations: { [weak self]  in
            guard let yPosition = self?.filtersButton.center.y else {return}
            self?.filtersButton.center.y = yPosition + distanceToMove
            self?.filtersButton.alpha = buttonTransparencyToBe
            let scaleFactor = distanceToMove < 0 ? 4 : 1
            let rotationDegrees = distanceToMove < 0  ? Double.pi : 0
            self?.filtersButton.transform = CGAffineTransform(scaleX: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
            self?.filtersButton.transform = CGAffineTransform(rotationAngle: rotationDegrees)
        }){(completed) in
            if completed{
                if self.downAnimationStarted{ self.view.bringSubviewToFront(self.filtersButton)}
                if self.upAnimationStarted {  self.view.sendSubviewToBack(self.filtersButton)}
            }
        }
    }
    
    //MARK: - SCROLLVIEW DELEGATE
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0 {
            scrollUpButtonAnimation()
            downAnimationStarted = true
            upAnimationStarted = false
        }
        else{
            scrollDownButtonAnimation()
            upAnimationStarted = true
            downAnimationStarted = false
            isFirstScroll = false
        }
    }
    
    //MARK: - Setups , Constraints
    private func prepareDateUIItems(){
        let currentDate = Date()
        updateLabel(with: currentDate)
        view.addSubview(trackerDatePicker)
        trackerDatePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        trackerDateLabel.addGestureRecognizer(tapGesture)
    }
    
    private func updateLabel(with date: Date) {
        trackerDateLabel.text = dateFormatter.string(from: date)
        trackerDatePicker.isHidden = true
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
        trackerSearchField.keyboardType = .default
        trackerSearchField.returnKeyType = .done
        trackerSearchField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        trackerSearchField.frame = CGRect(origin: .zero, size: CGSize(width: 288, height: 36))
        trackerDateLabel.backgroundColor = .trackerLightGray12
        
        view.addSubview(trackerSearchField)
        view.addSubview(screenTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: trackerDateLabel)
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
        
        containerViewHolder.addSubview(filtersButton)
        containerViewHolder.removeConstraints(containerViewHolder.constraints)
        hasToShowEmptyView =  (categories.isEmpty ||
                               (isActiveSearchFiltering && isEmptySearchResult)) || (isListToShowEmpty && pinCategory.trackers.isEmpty)
        
        if hasToShowEmptyView{
            filtersButton.isHidden = false
            if ((categoriesToShow.isEmpty && pinCategory.trackers.isEmpty) || (isActiveSearchFiltering && isEmptySearchResult)) {
                
                emptyMainScreenView.updateImageToShow(with: UIImage(named: "notFoundImage"))
                emptyMainScreenView.updateTextToShow(with: dictionaryUI.trackersViewEmptySearchText)
                containerViewHolder.bringSubviewToFront(filtersButton)
            }
            if categories.isEmpty {
                emptyMainScreenView.updateImageToShow(with: UIImage(named: "starMainScreen"))
                emptyMainScreenView.updateTextToShow(with: dictionaryUI.trackersViewHolderText)
                containerViewHolder.bringSubviewToFront(filtersButton)
            }
            
            emptyMainScreenView.prepareStarMainScreen()
            containerViewHolder.addSubview(emptyMainScreenView)
            emptyMainScreenView.frame = CGRect(x: 0, y: 0, width: containerViewHolder.frame.width, height: containerViewHolder.frame.height)
            
            NSLayoutConstraint.activate([
                filtersButton.centerXAnchor.constraint(equalTo: containerViewHolder.centerXAnchor),
                filtersButton.bottomAnchor.constraint(equalTo: containerViewHolder.bottomAnchor, constant: -16),
                filtersButton.widthAnchor.constraint(equalToConstant: 114),
                filtersButton.heightAnchor.constraint(equalToConstant: 50),
                emptyMainScreenView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor),
                emptyMainScreenView.leadingAnchor.constraint(equalTo: containerViewHolder.leadingAnchor),
                emptyMainScreenView.trailingAnchor.constraint(equalTo: containerViewHolder.trailingAnchor),
                emptyMainScreenView.bottomAnchor.constraint(equalTo: containerViewHolder.bottomAnchor),
                emptyMainScreenView.heightAnchor.constraint(equalTo: containerViewHolder.heightAnchor, multiplier: 1),
                emptyMainScreenView.widthAnchor.constraint(equalTo: containerViewHolder.widthAnchor, multiplier: 1)
            ])
            containerViewHolder.bringSubviewToFront(filtersButton)
        }
        else
        {
            filtersButton.isHidden = false
            containerViewHolder.addSubview(scrollView)
            
            if isFirstScroll{
                containerViewHolder.bringSubviewToFront(filtersButton)
            }
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: containerViewHolder.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: containerViewHolder.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: containerViewHolder.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: containerViewHolder.trailingAnchor),
                filtersButton.centerXAnchor.constraint(equalTo: containerViewHolder.centerXAnchor),
                filtersButton.bottomAnchor.constraint(equalTo: containerViewHolder.bottomAnchor, constant: -16),
                filtersButton.widthAnchor.constraint(equalToConstant: 114),
                filtersButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func setupContainerHolder(){
        for view in vStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        unpinnedTrackers = separetingTrackers(mainList: categories)
        categoriesToShow = filteringTrackersToShow(from: unpinnedTrackers, withFilter: isCustomFilterActivated.filter)
        
        if isActiveSearchFiltering {
            categoriesToShow = filteredData
            isActiveSearchFiltering = false
        }
        if categoriesToShow.isEmpty &&  pinCategory.trackers.isEmpty {
            isListToShowEmpty = true
        }else{
            isListToShowEmpty = false
            creatingCollectionsView(with: pinCategory, from: nil)
            
            for category in categoriesToShow {
                creatingCollectionsView(with: category, from: categoriesToShow)
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
    }
    
    private func creatingCollectionsView(with neededCategory: TrackerCategory, from parentList: [TrackerCategory]? ){
        if !neededCategory.trackers.isEmpty {
            let layout = UICollectionViewFlowLayout()
            let newTrackerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            newTrackerCollectionView.tag = (parentList?.firstIndex(of: neededCategory) ?? -1)
            newTrackerCollectionView.backgroundColor = .trackerWhite
            prepareTrackersCollectionView(for: newTrackerCollectionView)
            vStack.addArrangedSubview(newTrackerCollectionView)
            let collectionHeight = CGFloat((neededCategory.trackers.count / 2 + neededCategory.trackers.count % 2) * 148 + 30) // Refactoring gonna be later
            NSLayoutConstraint.activate([
                newTrackerCollectionView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                newTrackerCollectionView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                newTrackerCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionHeight))
            ])
            newTrackerCollectionView.reloadData()
        }
        containerViewHolder.bringSubviewToFront(filtersButton)
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
    
    //MARK: - FilteringEvents
    /// This function save pinned trackers in the class private variable pinnedCategory and at the same time return a list of categories without pinned trackers.
    private func separetingTrackers(mainList categories: [TrackerCategory])-> [TrackerCategory]{
        filteringEventsByPin(categories: categories)
        let unpinnedTrackersCategories = categories.compactMap { category -> TrackerCategory? in
            let unpinnedTrackers = category.trackers.filter { tracker in
                !tracker.isPinned
            }
            return unpinnedTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: unpinnedTrackers)
        }
        return unpinnedTrackersCategories
    }
    
    private func filteringEventsByDate(from categories: [TrackerCategory]) -> [TrackerCategory]{
        let selectedWeekday = Weekday(from: dateForFiltering ?? Date())
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(dateForFiltering ?? Date())
        let repCategories = categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let scheduledDays = tracker.schedule.scheduledDays else { return false }
                return (scheduledDays.contains { $0.scheduleDay == selectedWeekday && $0.isScheduled } || !(tracker.schedule.isAnHabit) && isToday) && !tracker.isPinned
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        return repCategories
    }
    
    private func filteringEventsByPin(categories: [TrackerCategory]){
        pinCategory.trackers.removeAll()
        for category in categories {
            let filteredTrackers = category.trackers.filter{tracker in
                tracker.isPinned
            }
            for tracker in filteredTrackers {
                pinCategory.trackers.append(tracker)
            }
        }
    }
    
    private func filteringCompletedTrackers(from categories: [TrackerCategory]) -> [TrackerCategory]{
        var completedTrackersCategories : [TrackerCategory] = []
        let recordsForFiltering = completedTrackersOnDateForFiltering()
        
        for category in categories {
            var completedTrackersInCategory: [Tracker] = []
            
            for tracker in category.trackers {
                if recordsForFiltering.contains(where: {
                    return $0.idCompletedTracker == tracker.id
                }){
                    completedTrackersInCategory.append(tracker)
                }
            }
            if !completedTrackersInCategory.isEmpty{
                completedTrackersCategories.append(TrackerCategory(title: category.title, trackers: completedTrackersInCategory))
            }
        }
        return completedTrackersCategories
    }
    
    private func filteringNotCompletedTrackers(from categories: [TrackerCategory]) -> [TrackerCategory]{
        var notCompletedTrackersCategories : [TrackerCategory] = []
        let recordsForFiltering = completedTrackersOnDateForFiltering()
        
        for category in categories {
            var notCompletedTrackersInCategory: [Tracker] = []
            
            for tracker in category.trackers {
                if !recordsForFiltering.contains(where: {
                    return $0.idCompletedTracker == tracker.id
                }){
                    notCompletedTrackersInCategory.append(tracker)
                }
            }
            if !notCompletedTrackersInCategory.isEmpty{
                notCompletedTrackersCategories.append(TrackerCategory(title: category.title, trackers: notCompletedTrackersInCategory))
            }
        }
        return notCompletedTrackersCategories
    }
    
    private func completedTrackersOnDateForFiltering() -> [TrackerRecord]{
        var completedTrackersToFilterWith : [TrackerRecord] = []
        do{
            if let dateForFiltering = dateForFiltering {
                completedTrackers = try trackerRecordStore.fetchTrackerRecords()
                completedTrackersToFilterWith =  completedTrackers.filter { record in
                    let recordDate = dateFormatter.string(from: record.dateTrackerCompleted)
                    let selectedDate = dateFormatter.string(from: dateForFiltering)
                    return recordDate == selectedDate
                }
            }
        }catch {
            print("Error fetching data: \(error)")
        }
        return completedTrackersToFilterWith
    }
    
    private func filteringTrackersToShow(from categoriesList: [TrackerCategory], withFilter filter: Filters?) -> [TrackerCategory]{
        var trackersToShow : [TrackerCategory] = []
        let filter = filter
        let isFilterActivated = isCustomFilterActivated.isFilterActivated
        
        if isFilterActivated && filter != nil{
            switch filter{
            case .today:  dateForFiltering = Date()
                trackersToShow = filteringEventsByDate(from: categoriesList)
            case .completed: trackersToShow = filteringCompletedTrackers(from: categoriesList)
            case .notCompleted: trackersToShow = filteringNotCompletedTrackers(from: categoriesList)
            default:  trackersToShow = filteringEventsByDate(from: categoriesList)
            }
        }else{
            trackersToShow = filteringEventsByDate(from: categoriesList)
        }
        return trackersToShow
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TrackersViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categoryIndex = collectionView.tag
        if categoryIndex < 0 {
            return pinCategory.trackers.count
        }else{
            return categoriesToShow[categoryIndex].trackers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackersCollectionViewCellIdentifier, for: indexPath) as? TrackerViewCell else {return TrackerViewCell()}
        let categoryIndex = collectionView.tag
        let currentEvent : Tracker
        if categoryIndex < 0 {
            currentEvent = pinCategory.trackers[indexPath.item]
        }
        else{
            currentEvent = categoriesToShow[categoryIndex].trackers[indexPath.item]
        }
        let eventTitle = currentEvent.name
        let colorName = currentEvent.colorName
        let emoji = currentEvent.emoji
        let eventId = currentEvent.id
        guard let dateText = trackerDateLabel.text else { return TrackerViewCell()}
        cell.prepareDataForUsing(colorName: colorName, eventTitle: eventTitle, emoji: emoji, trackerID: eventId, calendarDate: dateText)
        cell.preventingChangesInFuture(isNecesary: isTryingToChangeTheFuture)
        cell.willHidePin(is: !currentEvent.isPinned)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerSectionIdentifier + "\(collectionView.tag)", for: indexPath) as? MainHeaderCollectionView else { return MainHeaderCollectionView()}
        let categoryIndex =  collectionView.tag
        if categoryIndex < 0 {
            header.titleLabel.text = pinCategory.title
        }else{
            header.titleLabel.text = categoriesToShow[categoryIndex].title
        }
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
                        cell.willHidePin(is: true)
                        guard let trackerId = cell.getTrackerID() else {return}
                        self?.pinUnpinTracker(withId: trackerId, willBePined: false)  //Unpin Tracker
                    }
                    else{
                        cell.willHidePin(is: false)
                        guard let trackerId = cell.getTrackerID() else {return}
                        self?.pinUnpinTracker(withId: trackerId, willBePined: true)
                    }
                },
                UIAction(title: dictionaryUI.trackersViewContextMenuEdit) { [weak self] _ in
                    self?.appMetricAnalyticsService.mainScreenContextualMenuDidEditTap()
                    guard let trackerId = cell.getTrackerID() else {return}
                    self?.editTracker(withId: trackerId)
                },
                UIAction(title: dictionaryUI.trackersViewContextMenuDelete, attributes: .destructive) { [weak self] _ in
                    self?.appMetricAnalyticsService.mainScreenContextualMenuDidDeleteTap()
                    guard let self = self else {return}
                    
                    let deleteAction  = {[weak self] in
                        guard let trackerId = cell.getTrackerID() else {return}
                        self?.deleteTracker(withId: trackerId)
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
    
    //MARK: - CONTEXTUAL MENU FUNCTIONS
    private func pinUnpinTracker(withId trackerId: UUID, willBePined newValue: Bool){
        do {
            try trackerStore.pinUnpinTracker(id: trackerId, with: newValue)
        } catch {
            print("Failed to update the tracker: \(error.localizedDescription)")
        }
        reloadView()
    }
    private func editTracker(withId trackerId: UUID){
        eventToUpdate =  trackerStore.trackers.first(where: {$0.id == trackerId})
        let amountOfDaysTaskCompleted = trackerRecordStore.countingTimesCompleted(idCompletedTracker: trackerId)
        amountOfDaysText = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: ""), amountOfDaysTaskCompleted)
        
        let createHabitViewController = CreateHabitViewController(isAnHabit: true, isEditingAHabit: true)
        present(createHabitViewController, animated: true)
    }
    private func deleteTracker(withId trackerId: UUID){
        if trackerStore.trackers.contains(where: {$0.id == trackerId}) {
            do {
                try  trackerStore.deleteTracker(by: trackerId)
                try trackerCategoryStore.deleteEmptyCategories()
                reloadView()
            }catch{
                print("Failed trying to delete the tracker: \(error.localizedDescription)")
                return
            }
        }
        
    }
}

//MARK: TrackersViewController Extensions
extension TrackersViewController : TrackersViewControllerProtocol {
    func updateNewTracker(with categoryName: String, for eventToUpdate: Tracker) {
        do {
            try trackerStore.updateTrackerWith(this: eventToUpdate, from: categoryName)
            dateForFiltering = nil
        } catch {
            print("Error updating new tracker: \(error)")
        }
    }
    
    func saveNewTracker(with newCategoryName: String, for newEvent: Tracker) {
        
        do {
            try trackerCategoryStore.saveTrackerToCategory(tracker: newEvent, in: newCategoryName)
            dateForFiltering = Date()
            isListToShowEmpty = false
        } catch {
            print("Error saving new tracker: \(error)")
        }
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func storeRecord() {
        do{
            completedTrackers = try trackerRecordStore.fetchTrackerRecords()
            reloadView()
        }
        catch{
            fatalError(TrackerRecordStoreError.decodingErrorInvalidFetch.localizedDescription)
        }
    }
}

extension TrackersViewController : TrackerCategoryStoreDelegate{
    func storeCategoryDidChange() {
        guard let fetchedCategories = try? trackerCategoryStore.fetchTrackerCategories() else {return}
        self.categories = fetchedCategories
        self.setupContainerView()
        self.setupContainerHolder()
    }
}

extension TrackersViewController : FilterListViewControllerDelegate {
    func customFilterDidSelect(withFilter filter: Filters) {
        self.isCustomFilterActivated.isFilterActivated = true
        self.isCustomFilterActivated.filter = filter
        
        guard let currentDateText = trackerDateLabel.text else {return}
        dateForFiltering = dateFormatter.date(from: currentDateText)
        if filter == .today {
            dateForFiltering? = Date()
            trackerDatePicker.date = Date()
            trackerDateLabel.text = dateFormatter.string(from: Date())
        } else
        if filter == .byDate {
            self.isCustomFilterActivated.isFilterActivated = false
        }
        self.controlButtonColor()
        print(isCustomFilterActivated.isFilterActivated.description)
        reloadView()
    }
}

extension TrackersViewController : UIGestureRecognizerDelegate {
    
    func handleTapsOnScreen(){
        let tapTextFieldGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tapTextFieldGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapTextFieldGestureRecognizer)
    }
}

extension TrackersViewController :  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadView()
        return true
    }
}







