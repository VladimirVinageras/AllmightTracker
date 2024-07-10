//
//  CreateHabitViewController.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 13.05.2024.
//

import Foundation
import UIKit

final class CreateHabitViewController : UIViewController{
    var viewModel : TrackerCategoriesViewModel
    
    
    //MARK: Data
    private var eventTitle: String?
    private var selectedCategory: String?
    private var selectedDays: String?
    private var selectedColorName: String?
    private var selectedEmoji: String?
    
    
    private var weekDays: [ScheduleDay]?
    private var isAnHabit: Bool
    private var amountOfDaysText = ""
    private var isEditingAHabit : Bool
    var trackersViewControllerShared = TrackersViewController.shared
    let trackerCategoryStore = TrackerCategoryStore()
    
    private let colorsNameCollection: [String] = [
        "ColorSelection1", "ColorSelection2", "ColorSelection3" , "ColorSelection4", "ColorSelection5", "ColorSelection6",
        "ColorSelection7", "ColorSelection8", "ColorSelection9", "ColorSelection10",
        "ColorSelection11", "ColorSelection12",
        "ColorSelection13" , "ColorSelection14", "ColorSelection15", "ColorSelection16", "ColorSelection17", "ColorSelection18"]
    private let emojis : [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                     "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    //MARK: CollectionView related Variables
    let colorsCellIdentifier = "colorCell"
    let emojisCellIdentifier = "emojisCell"
    let headerSectionIdentifier = "header"
    private let interItemSpacing : CGFloat = 5
    private let interLinesSpacing : CGFloat = 1
    
    
   
    private var selectedEmojisCollectionIndexPath: IndexPath?
    private var selectedColorsCollectionIndexPath: IndexPath?
    
    
    //MARK: TableView related Variables
    
    private let parametersTableViewCellIdentifier = "viewTableCell"
    var keepWeekdaysDelegate: KeepingScheduleDaysProtocol?
    var trackerParametersTableViewTopConstraint : NSLayoutConstraint?
    
    //MARK: UI Elements
    private let scrollView: UIScrollView = {
        let scrllView = UIScrollView()
        scrllView.translatesAutoresizingMaskIntoConstraints = false
        scrllView.isScrollEnabled = true
        return scrllView
    }()
    private var colorsCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var emojisCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        return collectionView
    }()
    private lazy var viewTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .trackerBlack
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    private lazy var newHabitNameTextField : UITextField = {
        var newHabitTextField = UITextField()
        newHabitTextField.translatesAutoresizingMaskIntoConstraints = false
        newHabitTextField.backgroundColor = .trackerBackgroundDay
        newHabitTextField.layer.cornerRadius = 16
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        newHabitTextField.autocorrectionType = .no
        newHabitTextField.leftView = leftView
        newHabitTextField.leftViewMode = .always
        newHabitTextField.keyboardType = .default
        newHabitTextField.returnKeyType = .done
        newHabitTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return newHabitTextField
    }()
    private lazy var clearTextFieldButton : UIButton  = {
        let clearTextButton = UIButton(type: .custom)
        clearTextButton.setImage(UIImage(named: "xmark.circle"), for: .normal)
        clearTextButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        clearTextButton.contentMode = .scaleAspectFit
        clearTextButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearTextButton.isHidden = true
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        rightView.addSubview(clearTextButton)
        newHabitNameTextField.rightView = rightView
        newHabitNameTextField.rightViewMode = .whileEditing
        return clearTextButton
    }()
    private lazy var restrictionWarningLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dictionaryUI.createHabitViewLongTrackerTitleLimitText
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerRed
        label.isHidden = true
        return label
    }()
    
    
    private lazy var amountOfDaysLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        label.textColor = .trackerBlack
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let vStack : UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.spacing = 16
        return vstack
    }()
    
    private var trackerParametersTableView: UITableView = {
        var parametersTableView = UITableView()
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        return parametersTableView
    }()
    private lazy var cancelButton: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitleColor(.trackerRed, for: .normal)
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.trackerRed.cgColor
        cancelBtn.layer.cornerRadius = 16
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelBtn.setTitle(dictionaryUI.createHabitViewBtnCancelTitle, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        return cancelBtn
    }()
    private lazy var createEventButton: UIButton = {
        let createButton = UIButton(type: .custom)
        createButton.setTitleColor(.trackerWhite, for: .normal)
        createButton.backgroundColor = .trackerGray
        createButton.layer.cornerRadius = 16
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(self, action: #selector(createEventButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    @objc
    private func cancelBtnTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func createEventButtonTapped(){
        
        creatingOrEditingAnEvent()
        
        NotificationCenter.default.post(name: Notification.Name("ReloadTrackersViewController"), object: nil)
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Functions
    init(isAnHabit : Bool, isEditingAHabit: Bool){
        self.isEditingAHabit = isEditingAHabit
        self.isAnHabit = isAnHabit
        viewModel = TrackerCategoriesViewModel(trackerCategoryStore: trackerCategoryStore)
        
        super.init(nibName: nil, bundle: nil)
        
        if self.isEditingAHabit {
            
            if let trackerId = trackersViewControllerShared.eventToUpdate?.id {
                selectedCategory = (trackerCategoryStore.trackerCategories.first { category in
                    category.trackers.contains { tracker in
                        tracker.id == trackerId
                    }
                })?.title
            }
            eventTitle = trackersViewControllerShared.eventToUpdate?.name
            selectedDays = daysToString()
            weekDays = trackersViewControllerShared.eventToUpdate?.schedule.scheduledDays
            selectedEmoji = trackersViewControllerShared.eventToUpdate?.emoji
            selectedColorName = trackersViewControllerShared.eventToUpdate?.colorName
            amountOfDaysText = trackersViewControllerShared.amountOfDaysText
            
            amountOfDaysLabel.isHidden = false
            amountOfDaysLabel.text = amountOfDaysText
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        self.viewModel.selectedCategoryBinding = { [weak self] _ in
            guard let self = self else {return}
            self.selectedCategory = viewModel.selectedCategory?.title
            self.setupTableView()
            self.trackerParametersTableView.reloadData()
        }
        
        newHabitNameTextField.delegate = self
        setupCollectionViews()
        setupTableView()
        addingSubviews()
        activateConstraints()
        trackerParametersTableView.reloadData()
        creatingDayForNonHabitEvent()
        setupInitialUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGestureRecognizer.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if isEditingAHabit {
//           
//            if let selectedEmoji = selectedEmoji {
//                let emojiIndex = emojis.firstIndex(of: selectedEmoji) ?? 0
//                let emojiIndexPath = IndexPath(item: emojiIndex, section: 0)
//                emojisCollectionView.selectItem(at: emojiIndexPath, animated: false, scrollPosition: .centeredVertically)
//                emojisCollectionView.reloadData()
//            }
//            if let selectedColorName = selectedColorName {
//                let colorIndex = colorsNameCollection.firstIndex(of: selectedColorName) ?? 0
//                let colorIndexPath = IndexPath(item: colorIndex, section: 0)
//                colorsCollectionView.selectItem(at: colorIndexPath, animated: false, scrollPosition: .centeredVertically)
//            
//            }
            
   //     }
//        emojisCollectionView.reloadData()
//        colorsCollectionView.reloadData()
        trackerParametersTableView.reloadData()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    ///Function used exclusively in the CreateHabitViewController editing mode.  The function transform a schedule to a string of short representation of the days scheduled. The function use class internal properties.
    
    private func daysToString() -> String{
        var selectedShortDaysArray: [String] = []
        guard var daysSelected = trackersViewControllerShared.eventToUpdate?.schedule.scheduledDays else {return ""}
        daysSelected.sort{ dayFirst,daySecond  in
            return dayFirst.scheduleDay.rawValue < daySecond.scheduleDay.rawValue
        }
        for dayIndex in 0..<daysSelected.count {
            if daysSelected[dayIndex].isScheduled{
                let shortName = daysSelected[dayIndex].scheduleDay.shortDaysName
                selectedShortDaysArray.append(shortName)
            }
        }
        return selectedShortDaysArray.joined(separator: ", ")
    }
    
    private func creatingOrEditingAnEvent(){
        guard let selectedCategory = self.selectedCategory,
              let selectedColorName = self.selectedColorName,
              let selectedEmoji = self.selectedEmoji,
              let eventTitle = self.eventTitle
        else {return}
        
        let newCategoryName = selectedCategory
        let newTrackerSchedule = TrackerSchedule(id: UUID(), isAnHabit: isAnHabit, scheduledDays: weekDays)
        
        
        if isEditingAHabit {
            guard let trackerId = trackersViewControllerShared.eventToUpdate?.id else {return}
            let newTracker = Tracker(id: trackerId, name: eventTitle, colorName: selectedColorName, emoji: selectedEmoji, schedule: newTrackerSchedule, isPinned: false)
            trackersViewControllerShared.updateNewTracker(with: newCategoryName, for: newTracker)
        }else{
            let newTracker = Tracker(id: UUID(), name: eventTitle, colorName: selectedColorName, emoji: selectedEmoji, schedule: newTrackerSchedule, isPinned: false)
            trackersViewControllerShared.saveNewTracker(with: newCategoryName, for: newTracker)
        }
    }
    
    
    private func creatingDayForNonHabitEvent(){
        if !isAnHabit {
            guard let today = Weekday.init(from: Date()) else {return}
            let justToday = ScheduleDay(scheduleDay: today, isScheduled: isAnHabit)
            weekDays?.append(justToday)
        }
    }
    
    func setupInitialUI(){
        if isEditingAHabit {
            viewTitleLabel.text = dictionaryUI.createHabitViewEditingTitle
            newHabitNameTextField.text = eventTitle
            createEventButton.setTitle(dictionaryUI.createHabitViewBtnEditTitle, for: .normal)
        }
        else{
            viewTitleLabel.text = dictionaryUI.createHabitViewTitle
            newHabitNameTextField.placeholder = dictionaryUI.createHabitViewTextFieldHolderText
            createEventButton.setTitle(dictionaryUI.createHabitViewBtnCreateTitle, for: .normal)
            
        }
    }

    func setupCollectionViews(){
        
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.allowsMultipleSelection = false
        colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        scrollView.addSubview(colorsCollectionView)
        
        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojisCollectionView.allowsMultipleSelection = false
        emojisCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojisCell")
        emojisCollectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = self
        scrollView.addSubview(emojisCollectionView)
    }
    
    func setupTableView(){
        
        trackerParametersTableView.delegate = self
        trackerParametersTableView.dataSource = self
        trackerParametersTableView.register(TextLabelTableViewCell.self, forCellReuseIdentifier: parametersTableViewCellIdentifier)
        trackerParametersTableView.layer.cornerRadius = 16
        trackerParametersTableView.separatorStyle = .none
        trackerParametersTableView.isScrollEnabled = false
        trackerParametersTableView.updateConstraintsIfNeeded()
    }
    
    func addingSubviews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(vStack)
        vStack.addArrangedSubview(amountOfDaysLabel)
        vStack.addArrangedSubview(scrollView)
        
        scrollView.addSubview(newHabitNameTextField)
        scrollView.addSubview(restrictionWarningLabel)
        scrollView.addSubview(trackerParametersTableView)
        
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createEventButton)
    }
    
    private func updatingConstraints(){
        
        guard let trackerParametersTableViewTopConstraint = self.trackerParametersTableViewTopConstraint else {return}
        trackerParametersTableViewTopConstraint.isActive = true
        trackerParametersTableViewTopConstraint.constant = self.restrictionWarningLabel.isHidden ? 24 : 62
        self.view.layoutIfNeeded()
    }
    private func activateConstraints(){
        trackerParametersTableViewTopConstraint  = trackerParametersTableView.topAnchor.constraint(equalTo: newHabitNameTextField.bottomAnchor, constant: 24)
        guard let trackerParametersTableViewTopConstraint = self.trackerParametersTableViewTopConstraint else {return}
        
        NSLayoutConstraint.activate([
            amountOfDaysLabel.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 18),
            amountOfDaysLabel.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 16),
            amountOfDaysLabel.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: amountOfDaysLabel.bottomAnchor, constant: 40),
            scrollView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 20),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            viewTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            newHabitNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            newHabitNameTextField.centerXAnchor.constraint(equalTo: viewTitleLabel.centerXAnchor),
            newHabitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            newHabitNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            newHabitNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            restrictionWarningLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            restrictionWarningLabel.topAnchor.constraint(equalTo: newHabitNameTextField.bottomAnchor, constant: 8),
            trackerParametersTableViewTopConstraint,
            trackerParametersTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerParametersTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerParametersTableView.heightAnchor.constraint(equalToConstant: CGFloat(trackerParametersTableView.numberOfRows(inSection: 0)*75)),
            
            emojisCollectionView.topAnchor.constraint(equalTo: trackerParametersTableView.bottomAnchor, constant: 16),
            emojisCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            emojisCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -18),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorsCollectionView.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 16),
            colorsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 18),
            colorsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: colorsCollectionView.centerXAnchor, constant: -4),
            createEventButton.heightAnchor.constraint(equalToConstant: 60),
            createEventButton.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 16),
            createEventButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant:  -16),
            createEventButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createEventButton.leadingAnchor.constraint(equalTo: colorsCollectionView.centerXAnchor, constant: 4)
            
        ])
        
    }
    
    @objc func clearTextField(){
        clearTextFieldButton.isHidden = true
        newHabitNameTextField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let text = textField.text, text.count > 38 else {
            restrictionWarningLabel.isHidden = true
            return
        }
        restrictionWarningLabel.isHidden = false
        self.updatingConstraints()
        let index = text.index(text.startIndex, offsetBy: 38)
        textField.text = String(text.prefix(upTo: index))
        
    }
    
    private func canEventBeCreated() -> Bool{
        guard let text = eventTitle ,
              !text.isEmpty,
              let colorName = selectedColorName,
              let emoji = selectedEmoji,
              !emoji.isEmpty else {return false }
        return true
    }
    private func handleCreateEventButton(){
        if canEventBeCreated() {
            createEventButton.isEnabled = true
            createEventButton.backgroundColor = .trackerBlack
        }
        else{
            createEventButton.isEnabled = false
            createEventButton.backgroundColor = .trackerGray
        }
    }
    
}

//MARK: DATA SOURCE FUNCTIONS
extension CreateHabitViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojisCollectionView ? emojis.count : colorsNameCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView{
            guard let cell = emojisCollectionView.dequeueReusableCell(withReuseIdentifier: "emojisCell", for: indexPath) as? EmojiCollectionViewCell else { fatalError("Failed to dequeue EmojiCollectionViewCell") }
            
            cell.titleLabel.text = emojis[indexPath.item]
            cell.titleLabel.font = UIFont.systemFont(ofSize: 32)
            cell.layer.cornerRadius = 8
            
            if isEditingAHabit {
                selectedEmoji = trackersViewControllerShared.eventToUpdate?.emoji
                if let selectedEmoji = selectedEmoji {
                    guard let emojiIndex = emojis.firstIndex(where: {
                        $0.self == selectedEmoji }) else {fatalError("Failed to find the selected emoji index")}
                    let emojiIndexPath = IndexPath(row: emojiIndex, section: 0)
                  //  cell.backgroundColor = .trackerLightGray
                    selectedEmojisCollectionIndexPath = emojiIndexPath
                    handleSelection(for: collectionView, indexPath: indexPath, selectedIndexPath: &selectedEmojisCollectionIndexPath)
                    collectionView.selectItem(at: emojiIndexPath, animated: true, scrollPosition: .centeredVertically)
                    collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: emojiIndexPath)
                }
            }
            return cell
        }
        else{
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorsCollectionViewCell else {fatalError("Failed to dequeue ColorsCollectionViewCell")}
            
            let colorName = colorsNameCollection[indexPath.item]
            cell.colorName = colorName
            cell.colorView.backgroundColor = UIColor(named: colorName)
            cell.colorView.layer.cornerRadius = 8
            
            if isEditingAHabit {
                selectedColorName = trackersViewControllerShared.eventToUpdate?.colorName
                if let colorToSearch = selectedColorName {
                    guard let colorIndex = colorsNameCollection.firstIndex(of: colorToSearch) else {fatalError("Failed to find the selected color name index")}
                    let colorIndexPath = IndexPath(item: colorIndex, section: 0)
                    selectedColorsCollectionIndexPath = colorIndexPath
                    if (indexPath == colorIndexPath){
                        cell.layer.borderWidth = 3
                        cell.layer.borderColor = cell.colorView.backgroundColor?.withAlphaComponent(0.30).cgColor
                        cell.layer.cornerRadius = 8
                    }
                    handleCreateEventButton()
                } else {fatalError("Failed to assign the selected color value")}
                
            }
            return cell
        }
      
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? HeaderCollectionView else { return HeaderCollectionView()}
        header.titleLabel.text = collectionView == emojisCollectionView ? dictionaryUI.createHabitViewEmojisCollectionTitle : dictionaryUI.createHabitViewColorCollectionTitle
        return header
    }
}

//MARK: DELEGATE FLOW LAYOUT FUNCTIONS
extension CreateHabitViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interLinesSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newHabitNameTextField.resignFirstResponder()
        
        if collectionView == emojisCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            selectedEmoji = cell?.titleLabel.text
            cell?.backgroundColor = .trackerLightGray
            handleSelection(for: collectionView, indexPath: indexPath, selectedIndexPath: &selectedEmojisCollectionIndexPath)
            handleCreateEventButton()
            
        } else if collectionView == colorsCollectionView {
          
            let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
            cell?.layer.cornerRadius = 8
            selectedColorName = cell?.colorName
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.30).cgColor
            handleSelection(for: collectionView, indexPath: indexPath, selectedIndexPath: &selectedColorsCollectionIndexPath)
            handleCreateEventButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.backgroundColor = .trackerWhite
            selectedEmoji = nil
        }else if collectionView == colorsCollectionView {
                let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell
                cell?.layer.borderWidth = 0
            if !isEditingAHabit { selectedColorName = "" }
            }
        }
}

//MARK: -  DELEGATE AND DATASOURCE TABLEVIEW FUNCTIONS

extension CreateHabitViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 75 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return isAnHabit ? 2 : 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: parametersTableViewCellIdentifier,
                                                       for: indexPath) as? TextLabelTableViewCell
        else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.updateTitleCellLabel(with: dictionaryUI.createHabitViewCellCategory)
            if let selectedCategory = self.selectedCategory{
                cell.updateSelectedElementsLabel(with: selectedCategory)
            }
        }else {
            cell.updateTitleCellLabel(with: dictionaryUI.createHabitViewCellSchedule)
            if let selectedDays = self.selectedDays {
                cell.updateSelectedElementsLabel(with: selectedDays)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let addNewCategoryViewController = AddNewCategoryViewController(viewModel: viewModel)
            present(addNewCategoryViewController, animated: true)
        }
        else{
            let addNewTrackerScheduleViewController = AddNewTrackerScheduleViewController()
            addNewTrackerScheduleViewController.scheduleViewControllerDelegate = self
            present(addNewTrackerScheduleViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isAnHabit && indexPath.row == 0
        {
            let horizontalBarInset: CGFloat = 16
            let horizontalBarWidth = tableView.bounds.width - horizontalBarInset * 2
            let horizontalBarHeight: CGFloat = 1.0
            let horizontalBarX = horizontalBarInset
            let horizontalBarY = cell.frame.height - horizontalBarHeight
            let horizontalBarView = UIView(frame: CGRect(x: horizontalBarX, y: horizontalBarY, width: horizontalBarWidth, height: horizontalBarHeight))
            horizontalBarView.backgroundColor = .trackerGray
            cell.addSubview(horizontalBarView)
        }
    }
}
//MARK: - TEXTFIELD DELEGATE

extension CreateHabitViewController :  UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {return true}
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 39
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearTextFieldButton.isHidden = textField.text?.isEmpty ?? false
        eventTitle = textField.text
        handleCreateEventButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIGestureRecognizerDelegate Functions

extension CreateHabitViewController : UIGestureRecognizerDelegate {
    
    func handleTapsOnScreen(){
        let tapTextFieldGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tapTextFieldGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapTextFieldGestureRecognizer)
    }
    
    
    func handleSelection(for collectionView: UICollectionView, indexPath: IndexPath, selectedIndexPath: inout IndexPath?) {
        
        if let selected = selectedIndexPath, selected == indexPath {
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: selected)
            selectedIndexPath = nil
        } else {
            if let selected = selectedIndexPath {
                collectionView.deselectItem(at: selected, animated: true)
                collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: selected)
                selectedIndexPath = nil
            }
            
        }
        handleCreateEventButton()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
}

//MARK: - UIEventControllerProtocol

extension CreateHabitViewController : ScheduleViewControllerProtocol {
    func checkingSelectedDays() -> [ScheduleDay] {
        return weekDays ?? []
    }
    
    func updateEventSelectedDays(with newSelectedDays: String, and weekdays: [ScheduleDay]) {
        if newSelectedDays == "\(dictionaryUI.weekDayShortMonday), \(dictionaryUI.weekDayShortThuesday), \(dictionaryUI.weekDayShortWednesday), \(dictionaryUI.weekDayShortThursday), \(dictionaryUI.weekDayShortFriday), \(dictionaryUI.weekDayShortSaturday), \(dictionaryUI.weekDayShortSunday)"
        {
            selectedDays = dictionaryUI.createHabitViewEveryDayHabitText
        }else{
            selectedDays = newSelectedDays
        }
        self.weekDays = weekdays
        reloadTableViewCell(at: IndexPath(row: 1, section: 0))
    }
    
    
    
    private func reloadTableViewCell(at indexPath: IndexPath) {
        var indexPaths : [IndexPath] = []
        indexPaths.append(indexPath)
        trackerParametersTableView.reloadRows(at: indexPaths, with: .automatic)
    }
}
