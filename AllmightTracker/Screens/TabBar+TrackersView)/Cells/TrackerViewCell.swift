//{
//  TrackerViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 29.05.2024.
//

import Foundation
import UIKit

final class TrackerViewCell : UICollectionViewCell {
    
    

    private var color : UIColor = .clear
    private var eventTitle : String = ""
    private var emoji: String = ""

    private var completedTask : Bool = false
    private var amountOfDays = 0
    private var calendarDate = ""
    private var trackerRecordStore = TrackerRecordStore()
    private var trackerID: UUID?
    
    private var vStack : UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.spacing = 0
        return vstack
    }()
    
    private var hStack : UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.spacing = 8
        return hstack
    }()
    
    var trackerCard = TrackerCard()

    private var plusButton : UIButton = {
        var pButton = UIButton(type: .system)
        pButton.translatesAutoresizingMaskIntoConstraints = false
        pButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        pButton.backgroundColor = .green
        pButton.tintColor = .white
        pButton.layer.cornerRadius = 17
        pButton.layer.masksToBounds = true
        
        pButton.addTarget(self, action: #selector(cellPlusButtonTapped), for: .touchUpInside)
        return pButton
    }()
    
    private var daysLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vStack)
        prepareTrackerCard()
        prepareVerticalStack()
        activateAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func cellPlusButtonTapped() {
        guard let newDate = dateFormatter.date(from: calendarDate) else {return}
        if let trackerID = trackerID {
            completedTask.toggle()
                    do {
                        if completedTask {
                                try trackerRecordStore.addNewTrackerRecord(trackerID, completionDate: newDate)
                            trackerRecordStore.delegate?.storeRecord()
                            amountOfDays =
                            trackerRecordStore.countingTimesCompleted(idCompletedTracker: trackerID)
                        } else {
                            try trackerRecordStore.deleteTrackerRecord(idCompletedTracker: trackerID, completionDate: newDate)
                            trackerRecordStore.delegate?.storeRecord()
                            amountOfDays = trackerRecordStore.countingTimesCompleted(idCompletedTracker: trackerID)
                            amountOfDays = (amountOfDays < 0) ? 0 : amountOfDays
                        }
                    } catch {
                        print("Error saving tracker record: \(error)")
                    }
            
                }
                updatePlusButton()
                updateDaysLabelText()
    }
    
    private func updateDaysLabelText() {
        daysLabel.text = dayText(amountOfDays: amountOfDays)
    }
    
    private func updatePlusButton() {
        plusButton.backgroundColor = completedTask ? color.withAlphaComponent(0.3) : color
        let imageName = completedTask ? "checkmark" : "plus"
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        plusButton.setImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
        plusButton.tintColor = .trackerWhite
    }
    
  
    private func dayText(amountOfDays: Int) -> String{
        let amountOfDaysTaskCompleted = amountOfDays
        let daysTextString = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: ""),
            amountOfDaysTaskCompleted
        )
        return daysTextString
    }

    private func prepareTrackerCard(){
        trackerCard.color = color
        trackerCard.eventTitle = eventTitle
        trackerCard.emoji = emoji
        trackerCard.prepareCard()
    }
    
    private func prepareHorizontalStack(){
        updateDaysLabelText()
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        hStack.addSubview(plusButton)
        hStack.addSubview(daysLabel)
    }
    private func prepareVerticalStack(){
        trackerCard.prepareCard()
        prepareHorizontalStack()
        vStack.addSubview(trackerCard)
        vStack.addSubview(hStack)
    }
    

    func prepareDataForUsing(colorName: String, eventTitle: String, emoji: String, trackerID: UUID, calendarDate : String) {
        self.calendarDate = calendarDate
        self.color = UIColor(named: colorName) ?? .trackerGray
        self.eventTitle = eventTitle
        self.emoji = emoji
        self.trackerID = trackerID
        do{
            completedTask = try trackerRecordStore.fetchTrackerRecords().contains {
                dateFormatter.string(from: $0.dateTrackerCompleted)  == calendarDate && $0.idCompletedTracker == trackerID
            }
         
        }
        catch{
            print("\(TrackerStoreError.decodingErrorInvalidFetch)")
        }
        amountOfDays = trackerRecordStore.countingTimesCompleted(idCompletedTracker: trackerID)
        
        prepareTrackerCard()
        updatePlusButton()
        prepareVerticalStack()
    }
    
    func preventingChangesInFuture(isNecesary isTryingToChangeTheFuture: Bool){
        plusButton.isEnabled = !isTryingToChangeTheFuture
    }
    
    func activateAllConstraints(){
        NSLayoutConstraint.activate([
        vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
        vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        vStack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        
        trackerCard.topAnchor.constraint(equalTo: vStack.topAnchor),
        trackerCard.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
        trackerCard.heightAnchor.constraint(equalToConstant: 90),
        trackerCard.widthAnchor.constraint(equalToConstant: 167),
        
        hStack.topAnchor.constraint(equalTo: trackerCard.bottomAnchor),
        hStack.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
        hStack.widthAnchor.constraint(equalToConstant: 167),
        hStack.heightAnchor.constraint(equalToConstant: 58),
        
        plusButton.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 8),
        plusButton.trailingAnchor.constraint(equalTo: hStack.trailingAnchor, constant: -12),
        plusButton.heightAnchor.constraint(equalToConstant: 34),
        plusButton.widthAnchor.constraint(equalToConstant: 34),
        
        daysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
        daysLabel.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: 12),
        daysLabel.heightAnchor.constraint(equalToConstant: 18),
        daysLabel.widthAnchor.constraint(equalToConstant: 101)
    
        ])
    }
    
    
    func getTrackerID() -> UUID? {
        return trackerID
    }
    
    func getTrackerCard()-> UIViewController {
        
        var temporalTrackerCard = TrackerCard(color: color, eventTitle: eventTitle, emoji: emoji)
        let trackerCardViewController = UIViewController()
        trackerCardViewController.view.backgroundColor = color
        trackerCardViewController.view.frame = CGRect(x: 0, y: 0, width: temporalTrackerCard.bounds.width, height: temporalTrackerCard.bounds.height)
        trackerCardViewController.view.layer.cornerRadius = 0
        trackerCardViewController.view.clipsToBounds = true
        temporalTrackerCard.center = trackerCardViewController.view.center
        trackerCardViewController.view.addSubview(temporalTrackerCard)
        trackerCardViewController.preferredContentSize = CGSize(width: temporalTrackerCard.frame.width , height: temporalTrackerCard.frame.height)
        return trackerCardViewController
    }
    
    
    func willHidePin(is toHide: Bool) {
        trackerCard.pinnedEvent.isHidden = toHide
    }
    
    func isPinHidden() -> Bool{
        return trackerCard.pinnedEvent.isHidden
    }

}

