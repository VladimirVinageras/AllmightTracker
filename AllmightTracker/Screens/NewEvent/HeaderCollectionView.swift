//
//  HeaderCollectionView.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 20.05.2024.
//

import Foundation
import UIKit


final class HeaderCollectionView: UICollectionReusableView {
    
    let label: UILabel
    
    override init(frame: CGRect) {
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "SFPro", size: 19)
        label.textColor = .trackerBlack
        super.init(frame: frame)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
