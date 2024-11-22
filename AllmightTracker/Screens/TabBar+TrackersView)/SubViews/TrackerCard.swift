//
//  TrackerCard.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 27.06.2024.
//

import Foundation
import UIKit

final class TrackerCard : UIView{
    
    private var color : UIColor
    private var eventTitle : String
    private var emoji : String
    private var titleEventLabel = UILabel()
    private var emojiLabel = UIButton(type: .system)
    private(set) var pinnedEvent = UIImageView()
    
    init(color: UIColor, eventTitle: String, emoji: String) {
        self.color = color
        self.eventTitle = eventTitle
        self.emoji = emoji
        super.init(frame: .zero)
        
        setupUI()
        prepareCard()
    }
    
    init(){
        self.color = .clear
        self.eventTitle = ""
        self.emoji = ""
        super.init(frame: .zero)
        
        setupUI()
        prepareCard()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        layer.cornerRadius = 16
        layer.frame = CGRect(x: 0, y: 0, width: 167, height: 90)
        
        titleEventLabel.textAlignment = .left
        titleEventLabel.textColor = .trackerWhite
        titleEventLabel.numberOfLines = 2
        titleEventLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleEventLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emojiLabel.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.backgroundColor = .trackerWhite.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emojiLabel.titleLabel?.textAlignment = .center
        emojiLabel.isEnabled = false
        
        pinnedEvent = UIImageView()
        pinnedEvent.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        pinnedEvent.image = UIImage(named: "pinSquare")
        pinnedEvent.translatesAutoresizingMaskIntoConstraints = false
        pinnedEvent.backgroundColor = .clear
        pinnedEvent.layer.masksToBounds = true
        pinnedEvent.isHidden = true
        
        self.addSubview(emojiLabel)
        self.addSubview(titleEventLabel)
        self.addSubview(pinnedEvent)
        
    }
    func prepareCard(){
        backgroundColor = color
        titleEventLabel.text = eventTitle
        emojiLabel.setTitle(emoji, for: .normal)
        
        
        NSLayoutConstraint.activate([
            
            emojiLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            pinnedEvent.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            pinnedEvent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -12),
            pinnedEvent.heightAnchor.constraint(equalToConstant: 12),
            pinnedEvent.widthAnchor.constraint(equalToConstant: 8),
            
            
            titleEventLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleEventLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            titleEventLabel.heightAnchor.constraint(equalToConstant: 34),
            titleEventLabel.widthAnchor.constraint(equalToConstant: 143)
        ])
    }
    
    func updateTrackerCard(color: UIColor, eventTitle: String, emoji: String) {
        self.color = color
        self.eventTitle = eventTitle
        self.emoji = emoji
    }
}
