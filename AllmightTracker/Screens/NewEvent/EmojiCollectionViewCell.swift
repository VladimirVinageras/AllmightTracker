//
//  EmojisCollectionViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 15.05.2024.
//

import Foundation
import UIKit

final class EmojiCollectionViewCell : UICollectionViewCell {
    var titleLabel : UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
       
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
