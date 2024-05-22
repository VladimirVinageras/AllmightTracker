//
//  ColorsCollectionViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 15.05.2024.
//

import Foundation
import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell{
    
    var colorView  = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
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
