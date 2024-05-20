//
//  ColorsCollectionViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 15.05.2024.
//

import Foundation
import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell{
    
    var colorView : UIView = {
        var colorRect = UIView(frame: .zero)
        colorRect.translatesAutoresizingMaskIntoConstraints = false
        return colorRect
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
