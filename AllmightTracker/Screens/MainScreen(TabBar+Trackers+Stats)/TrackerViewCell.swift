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
    private var emoji : String = ""
    private var completedTask : Bool = false
    private var amountOfDays = 0
    private var calendarDate = Date()
    private var trackerRecordStore = TrackerRecordStore()
    
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
    
    private var trackerCard : UIView = {
        let card = UIView(frame: CGRect(x: 0, y: 0, width: 167, height: 90))
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    private var titleEventLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var emojiLabel : UIButton = {
        let label = UIButton(type: .system)
        label.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .trackerWhite.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.titleLabel?.textAlignment = .center
        label.isEnabled = false
        return label
    }()

    private var plusButton : UIButton = {
        var pButton = UIButton(type: .system)
        pButton.translatesAutoresizingMaskIntoConstraints = false
        pButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        pButton.backgroundColor = .green
        pButton.tintColor = .white
        pButton.layer.cornerRadius = 17
        pButton.layer.masksToBounds = true
        
        pButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return pButton
    }()
    
    private var daysLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func plusButtonTapped() {
        completedTask.toggle()
        amountOfDays = completedTask ? amountOfDays + 1 : amountOfDays - 1
        updateDaysLabelText()
        updatePlusButton()
        
        if let trackerID = trackerID {
                    do {
                        if completedTask {
                            try trackerRecordStore.addNewTrackerRecord(trackerID, completionDate: calendarDate)
                            trackerRecordStore.delegate?.storeRecord()
                        } else {
                            //TODO: - Implement removing records when task is marked as not completed
                        }
                    } catch {
                        print("Error saving tracker record: \(error)")
                    }
                }
    }
    
    private func updateDaysLabelText() {
        daysLabel.text = "\(amountOfDays) \(dayText(amountOfDays: amountOfDays))"
    }
    
    private func updatePlusButton() {
        plusButton.backgroundColor = completedTask ? color.withAlphaComponent(0.3) : color
        let imageName = completedTask ? "checkmark" : "plus"
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        plusButton.setImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
    }
    
    private var trackerID: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vStack)
        prepareVerticalStack()
        activateAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func dayText(amountOfDays: Int) -> String{
        switch amountOfDays {
        case 1: return "день"
        case 2...4: return "дня"
        default: return "дней"
        }
    }
    
    private func prepareCard(){
    
        trackerCard.addSubview(emojiLabel)
        
        titleEventLabel.text = eventTitle
        titleEventLabel.textAlignment = .left
        titleEventLabel.textColor = .trackerWhite
        titleEventLabel.numberOfLines = 2
        titleEventLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerCard.addSubview(titleEventLabel)
        trackerCard.backgroundColor = color
        trackerCard.layer.cornerRadius = 16
  
    }
    
    
    private func prepareHorizontalStack(){
        
        updateDaysLabelText()
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        hStack.addSubview(plusButton)
        hStack.addSubview(daysLabel)
    }
    private func prepareVerticalStack(){
        prepareCard()
        prepareHorizontalStack()
        vStack.addSubview(trackerCard)
        vStack.addSubview(hStack)
    }
    

    func prepareDataForUsing(color: UIColor, eventTitle: String, emoji: String, completedTask: Bool, trackerID: UUID, calendarDate : Date) {
        self.calendarDate = calendarDate
        self.color = color
        self.eventTitle = eventTitle
        self.emoji = emoji
        self.completedTask = completedTask
        self.trackerID = trackerID
        
        emojiLabel.backgroundColor = .trackerWhite.withAlphaComponent(0.3)
        emojiLabel.setTitle(emoji, for: .normal)
        trackerCard.backgroundColor = color
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
        
        emojiLabel.topAnchor.constraint(equalTo: trackerCard.topAnchor, constant: 12),
        emojiLabel.leadingAnchor.constraint(equalTo: trackerCard.leadingAnchor, constant: 12),
        emojiLabel.heightAnchor.constraint(equalToConstant: 24),
        emojiLabel.widthAnchor.constraint(equalToConstant: 24),
        
        titleEventLabel.centerXAnchor.constraint(equalTo: trackerCard.centerXAnchor),
        titleEventLabel.bottomAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: -12),
        titleEventLabel.heightAnchor.constraint(equalToConstant: 34),
        titleEventLabel.widthAnchor.constraint(equalToConstant: 143),
        
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
    
    
}

