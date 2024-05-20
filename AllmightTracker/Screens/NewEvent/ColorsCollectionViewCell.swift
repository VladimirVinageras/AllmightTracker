//
//  ColorsCollectionViewCell.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 15.05.2024.
//

import Foundation
import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell{
    
    var colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.frame = CGRect(x: (contentView.bounds.width - 40)/2, y: (contentView.bounds.height - 40)/2, width: 40, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
