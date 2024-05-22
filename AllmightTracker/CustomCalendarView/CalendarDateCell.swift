//
//  CalendarDateCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 23.05.2024.
//

import Foundation
import UIKit

class CalendarDateCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        activateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
